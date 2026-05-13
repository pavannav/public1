#!/bin/bash
# process_course.sh v3 — Generic study guide generator for ANY course.
#
# FILE TYPES HANDLED:
#   Type 1 — Sections (N.M pattern):  "2.1 Intro.txt", "5.3 Joins.txt"
#             → Files with the same leading integer are grouped and processed together.
#             → Output: section-02-intro.md
#
#   Type 2 — Individual sessions (everything else):  "Session-01-Foo.txt", "Day 01 - Intro.txt"
#             → Each file processed on its own, output named from the filename.
#             → Output: day-01-intro.md
#
# KEY DESIGN:
#   v1 — Pasted transcript content into prompt (low quality, token pressure)
#   v2 — Told Claude to write the file itself (unreliable, Claude often skipped it)
#   v3 — Claude outputs markdown to stdout, shell redirects it to the file (reliable)
#
#   Claude is told to output ONLY raw markdown. The shell captures stdout and
#   writes it to the output file. Claude never needs to use its Write tool.
#
# Usage:
#   bash process_course_v3.sh \
#     --transcripts  "/path/to/course-transcripts" \
#     --output       "/path/to/output-folder" \
#     --instructions "/path/to/Study_Guide_Workflow_Instructions.md" \
#     --model-id     "Claude-Sonnet-4-5"
#
# Options:
#   --start-section N   Skip Type 1 sections below this number (resume support)
#   --start-session N   Skip Type 2 sessions below this number (resume support)
#   --type              "sections", "sessions", or "all" (default: all)
#   --sleep N           Seconds between calls (default: 5)
#   --retries N         Max retries per item on failure (default: 3)
#
# Resume safety:
#   Already-existing non-empty output files are skipped automatically.

set -uo pipefail

# ── Parse arguments ────────────────────────────────────────────────────────────
TRANSCRIPT_DIR=""
OUTPUT_DIR=""
INSTRUCTIONS_FILE=""
MODEL_ID="Claude-Sonnet-4-5"
SLEEP_BETWEEN=5
START_SECTION=1
START_SESSION=1
PROCESS_TYPE="all"
MAX_RETRIES=3

while [[ $# -gt 0 ]]; do
    case "$1" in
        --transcripts)   TRANSCRIPT_DIR="$2";   shift 2 ;;
        --output)        OUTPUT_DIR="$2";        shift 2 ;;
        --instructions)  INSTRUCTIONS_FILE="$2"; shift 2 ;;
        --model-id)      MODEL_ID="$2";          shift 2 ;;
        --start-section) START_SECTION="$2";     shift 2 ;;
        --start-session) START_SESSION="$2";     shift 2 ;;
        --type)          PROCESS_TYPE="$2";      shift 2 ;;
        --sleep)         SLEEP_BETWEEN="$2";     shift 2 ;;
        --retries)       MAX_RETRIES="$2";       shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

# ── Validate ───────────────────────────────────────────────────────────────────
if [[ -z "$TRANSCRIPT_DIR" || -z "$OUTPUT_DIR" || -z "$INSTRUCTIONS_FILE" ]]; then
    echo "Usage: $0 --transcripts DIR --output DIR --instructions FILE [options]"
    echo ""
    echo "Options:"
    echo "  --model-id ID        Model name shown in <summary> tag (default: Claude-Sonnet-4-5)"
    echo "  --start-section N    Resume Type 1 from section N (default: 1)"
    echo "  --start-session N    Resume Type 2 from session N (default: 1)"
    echo "  --type TYPE          Process 'sections', 'sessions', or 'all' (default: all)"
    echo "  --sleep N            Seconds between calls (default: 5)"
    echo "  --retries N          Max retries per item (default: 3)"
    exit 1
fi

[[ ! -d "$TRANSCRIPT_DIR" ]]    && { echo "❌ Transcript dir not found: $TRANSCRIPT_DIR"; exit 1; }
[[ ! -f "$INSTRUCTIONS_FILE" ]] && { echo "❌ Instructions file not found: $INSTRUCTIONS_FILE"; exit 1; }
mkdir -p "$OUTPUT_DIR"
command -v claude &>/dev/null   || { echo "❌ 'claude' CLI not found."; exit 1; }

DONE=0; SKIPPED=0; FAILED=0
LOG="$OUTPUT_DIR/process_course.log"

log()     { echo "$1" | tee -a "$LOG"; }
log_err() { echo "$1" | tee -a "$LOG" >&2; }

log "🚀 Starting — $(date)"
log "   TRANSCRIPTS  : $TRANSCRIPT_DIR"
log "   OUTPUT       : $OUTPUT_DIR"
log "   INSTRUCTIONS : $INSTRUCTIONS_FILE"
log "   MODEL ID     : $MODEL_ID"
log "   MAX RETRIES  : $MAX_RETRIES"

# ── Helper: clean a string into a safe filename slug ──────────────────────────
slugify() {
    echo "$1" \
        | sed 's/\.txt$//' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\+/-/g' \
        | sed 's/^-//;s/-$//'
}

# ── Helper: build prompt ───────────────────────────────────────────────────────
# Claude is told to output ONLY raw markdown to stdout.
# The shell captures this and writes it to the output file.
# Claude does NOT need to use its Write tool — file writing is the shell's job.
build_prompt() {
    local task="$1"       # human-readable description of what to process
    local files="$2"      # newline-separated list of full transcript file paths

    cat << EOF
Follow the workflow instructions in this file: $INSTRUCTIONS_FILE

YOUR TASK: $task

TRANSCRIPT FILES TO READ (use your Read tool on each one):
$files

MODEL ID FOR SUMMARY TAG: $MODEL_ID

STEPS TO FOLLOW IN ORDER:
1. Read the workflow instructions file: $INSTRUCTIONS_FILE
2. Read ALL transcript files listed above completely using your Read tool.
   Do not skip any file or any part of any file.
3. Generate the complete study guide following the workflow instructions exactly.
4. Wrap the entire output in:
   <details open>
   <summary><b>[Session/Section Name] ($MODEL_ID)</b></summary>
   [study guide content]
   </details>

OUTPUT RULES — CRITICAL:
- Output ONLY the raw markdown content. Nothing else.
- Do NOT include any preamble, explanation, status message, or commentary.
- Do NOT say "Here is the study guide" or anything similar.
- Do NOT use Write tool — the shell will capture your stdout and save it.
- Your entire response must be valid markdown starting with the <details> tag.
EOF
}

# ── Helper: call Claude and redirect stdout to output file ─────────────────────
# Claude outputs raw markdown to stdout.
# The shell writes stdout directly to the output file.
# stderr goes to the log for debugging.
call_claude() {
    local prompt="$1"
    local output_file="$2"
    local label="$3"
    local attempt=1
    local success=false

    while (( attempt <= MAX_RETRIES )); do
        if (( attempt > 1 )); then
            log "🔄 Retry $attempt / $MAX_RETRIES — $label"
            sleep "$SLEEP_BETWEEN"
        fi

        log "   Running claude..."

        # stdout → output file | stderr → log file
        # Claude outputs markdown, shell captures and saves it
        claude --print --permission-mode acceptEdits "$prompt" \
            > "$output_file" \
            2>> "$LOG"

        # Verify the output file is non-empty and looks like markdown
        if [[ -f "$output_file" && -s "$output_file" ]]; then
            local size
            size=$(wc -c < "$output_file")
            log "✅ DONE  $label → $(basename "$output_file") (${size} bytes)"
            (( DONE++ )) || true
            success=true
            break
        else
            log_err "⚠️  Empty or missing output after attempt $attempt — $label"
            # Remove empty file if created
            [[ -f "$output_file" ]] && rm -f "$output_file"
        fi

        (( attempt++ )) || true
    done

    if [[ "$success" == false ]]; then
        log_err "❌ FAIL  $label — no output after $MAX_RETRIES attempts"
        (( FAILED++ )) || true
    fi

    sleep "$SLEEP_BETWEEN"
}

# ============================================================================
# TYPE 1: SECTION FILES  (match N.M pattern — e.g. "2.1 Intro.txt")
# ============================================================================
if [[ "$PROCESS_TYPE" == "all" || "$PROCESS_TYPE" == "sections" ]]; then
    log ""
    log "══════════════════════════════════════════"
    log "  TYPE 1: Section files (N.M pattern)"
    log "══════════════════════════════════════════"

    SECTION_FILES_ALL=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            if echo "$fname" | grep -qE '^[0-9]+\.[0-9]+'; then echo "$f"; fi
          done) || true

    SECTION_NUMBERS=$(echo "$SECTION_FILES_ALL" \
        | while IFS= read -r f; do
            basename "$f" | grep -oE '^[0-9]+'
          done \
        | sort -un) || true

    if [[ -z "$SECTION_NUMBERS" ]]; then
        log "ℹ️  No N.M-style section files found."
    else
        TOTAL_SECTIONS=$(echo "$SECTION_NUMBERS" | wc -l | tr -d ' ')
        log "📚 Found $TOTAL_SECTIONS sections."

        while IFS= read -r SECTION_NUM <&3; do
            if (( SECTION_NUM < START_SECTION )); then
                log "⏭️  SKIP  Section $SECTION_NUM (below --start-section $START_SECTION)"
                (( SKIPPED++ )) || true
                continue
            fi

            SECTION_FILES=$(echo "$SECTION_FILES_ALL" \
                | while IFS= read -r f; do
                    fname=$(basename "$f")
                    leading=$(echo "$fname" | grep -oE '^[0-9]+')
                    [[ "$leading" == "$SECTION_NUM" ]] && echo "$f"
                  done) || true

            [[ -z "$SECTION_FILES" ]] && {
                log "⚠️  WARN  Section $SECTION_NUM — no files found. Skipping."
                continue
            }

            FIRST=$(basename "$(echo "$SECTION_FILES" | head -1)")
            TITLE=$(slugify "$(echo "$FIRST" | sed -E 's/^[0-9]+\.[0-9]+[[:space:]]*//')")
            [[ -z "$TITLE" ]] && TITLE="section"

            PADDED=$(printf "%02d" "$SECTION_NUM")
            OUTPUT_FILE="$OUTPUT_DIR/section-${PADDED}-${TITLE}.md"

            if [[ -f "$OUTPUT_FILE" && -s "$OUTPUT_FILE" ]]; then
                log "⏭️  SKIP  Section $SECTION_NUM → $(basename "$OUTPUT_FILE") (exists)"
                (( SKIPPED++ )) || true
                continue
            fi

            FILE_COUNT=$(echo "$SECTION_FILES" | wc -l | tr -d ' ')
            log ""
            log "▶ Processing Section $SECTION_NUM / $TOTAL_SECTIONS ($FILE_COUNT files)  [$(date +%H:%M:%S)]"
            log "  Output: $(basename "$OUTPUT_FILE")"

            PROMPT=$(build_prompt \
                "Create a study guide for Section $SECTION_NUM. All sub-topics across all files in this section must be covered." \
                "$SECTION_FILES")

            call_claude "$PROMPT" "$OUTPUT_FILE" "Section $SECTION_NUM"

        done 3<<< "$SECTION_NUMBERS"
    fi
fi

# ============================================================================
# TYPE 2: INDIVIDUAL SESSION FILES  (everything that is NOT N.M pattern)
# ============================================================================
if [[ "$PROCESS_TYPE" == "all" || "$PROCESS_TYPE" == "sessions" ]]; then
    log ""
    log "══════════════════════════════════════════"
    log "  TYPE 2: Individual session files"
    log "══════════════════════════════════════════"

    SESSION_FILES=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            if ! echo "$fname" | grep -qE '^[0-9]+\.[0-9]+'; then echo "$f"; fi
          done) || true

    if [[ -z "$SESSION_FILES" ]]; then
        log "ℹ️  No individual session files found."
    else
        SESSION_COUNT=$(echo "$SESSION_FILES" | wc -l | tr -d ' ')
        log "📄 Found $SESSION_COUNT individual session files."

        SESSION_INDEX=0
        while IFS= read -r f <&3; do
            [[ -z "$f" ]] && continue
            (( SESSION_INDEX++ )) || true

            if (( SESSION_INDEX < START_SESSION )); then
                log "⏭️  SKIP  Session $SESSION_INDEX (below --start-session $START_SESSION)"
                (( SKIPPED++ )) || true
                continue
            fi

            fname=$(basename "$f")
            TITLE=$(slugify "$fname")
            OUTPUT_FILE="$OUTPUT_DIR/${TITLE}.md"

            if [[ -f "$OUTPUT_FILE" && -s "$OUTPUT_FILE" ]]; then
                log "⏭️  SKIP  $(basename "$OUTPUT_FILE") (exists)"
                (( SKIPPED++ )) || true
                continue
            fi

            log ""
            log "▶ Processing Session $SESSION_INDEX / $SESSION_COUNT: $fname  [$(date +%H:%M:%S)]"
            log "  Output: $(basename "$OUTPUT_FILE")"

            PROMPT=$(build_prompt \
                "Create a study guide for the session: $fname" \
                "$f")

            call_claude "$PROMPT" "$OUTPUT_FILE" "Session: $fname"

        done 3<<< "$SESSION_FILES"
    fi
fi

# ── Final Summary ──────────────────────────────────────────────────────────────
log ""
log "═══════════════════════════════════"
log "  ✅ Done:    $DONE"
log "  ⏭  Skipped: $SKIPPED"
log "  ❌ Failed:  $FAILED"
log "  📋 Log:     $LOG"
log "═══════════════════════════════════"