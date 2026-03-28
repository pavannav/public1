#!/bin/bash
# process_course.sh — Generic study guide generator for ANY course.
#
# FILE TYPES HANDLED:
#   Type 1 — Sections (N.M pattern):  "2.1 Intro.txt", "5.3 Joins.txt"
#             → Files with the same leading integer are grouped and processed together.
#             → Output: section-02-intro.md, section-05-joins.md
#
#   Type 2 — Individual sessions (everything else):  "Session-01-Foo.txt", "Introduction.txt", "Bonus.txt"
#             → Each file processed on its own, output named from the filename.
#             → Output: session-session-01-foo.md, session-introduction.md
#
# Usage:
#   bash process_course.sh \
#     --transcripts "/path/to/course-transcripts" \
#     --output      "/path/to/output-folder" \
#     --instructions "/path/to/Study_Guide_Workflow_Instructions.md" \
#     --model-id    "G3PCS46"
#
# Options:
#   --start-section N   Skip Type 1 sections below this number (resume support)
#   --type              "sections", "sessions", or "all" (default: all)
#   --sleep N           Seconds between API calls (default: 3)
#
# Prerequisites:
#   - Claude CLI:  npm install -g @anthropic-ai/claude-cli
#   - Auth:        claude auth
#
# Resume safety:
#   Already-existing output files are skipped automatically.

set -uo pipefail  # no -e: grep exits 1 on no-match which would kill the script

# ── Parse arguments ────────────────────────────────────────────────────────────
TRANSCRIPT_DIR=""
OUTPUT_DIR=""
INSTRUCTIONS_FILE=""
MODEL_ID="G3PCS46"
SLEEP_BETWEEN=3
START_SECTION=1
PROCESS_TYPE="all"   # "sections", "sessions", or "all"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --transcripts)   TRANSCRIPT_DIR="$2";   shift 2 ;;
        --output)        OUTPUT_DIR="$2";        shift 2 ;;
        --instructions)  INSTRUCTIONS_FILE="$2"; shift 2 ;;
        --model-id)      MODEL_ID="$2";          shift 2 ;;
        --start-section) START_SECTION="$2";     shift 2 ;;
        --type)          PROCESS_TYPE="$2";      shift 2 ;;
        --sleep)         SLEEP_BETWEEN="$2";     shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

# ── Validate ───────────────────────────────────────────────────────────────────
if [[ -z "$TRANSCRIPT_DIR" || -z "$OUTPUT_DIR" || -z "$INSTRUCTIONS_FILE" ]]; then
    echo "Usage: $0 --transcripts DIR --output DIR --instructions FILE [options]"
    echo "  --model-id ID       Model name for <summary> tag (default: G3PCS46)"
    echo "  --start-section N   Resume from section N (default: 1)"
    echo "  --type TYPE         Process 'sections', 'sessions', or 'all' (default: all)"
    echo "  --sleep N           Seconds between API calls (default: 3)"
    exit 1
fi

[[ ! -d "$TRANSCRIPT_DIR" ]] && { echo "❌ Transcript dir not found: $TRANSCRIPT_DIR"; exit 1; }
[[ ! -f "$INSTRUCTIONS_FILE" ]] && { echo "❌ Instructions file not found: $INSTRUCTIONS_FILE"; exit 1; }
mkdir -p "$OUTPUT_DIR"
command -v claude &>/dev/null || { echo "❌ 'claude' CLI not found. Install: npm install -g @anthropic-ai/claude-cli"; exit 1; }

INSTRUCTIONS=$(cat "$INSTRUCTIONS_FILE")
DONE=0; SKIPPED=0; FAILED=0

# ── Helper: call Claude and write to output file ───────────────────────────────
call_claude() {
    local prompt="$1"
    local output_file="$2"
    local label="$3"

    local result exit_code
    result=$(echo "$prompt" | claude 2>&1) || result=""
    exit_code=$?

    if [[ $exit_code -ne 0 || -z "$result" ]]; then
        result=$(claude -p "$prompt" 2>&1) || result=""
        exit_code=$?
    fi

    if [[ $exit_code -eq 0 && -n "$result" ]]; then
        echo "$result" > "$output_file"
        echo "✅ DONE  $label → $(basename "$output_file")"
        (( DONE++ )) || true
    else
        echo "❌ FAIL  $label"
        [[ -n "$result" ]] && echo "$result" | head -3
        (( FAILED++ )) || true
    fi
    sleep "$SLEEP_BETWEEN"
}

# ── Helper: clean a string into a safe filename slug ──────────────────────────
slugify() {
    echo "$1" \
        | sed 's/\.txt$//' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\+/-/g' \
        | sed 's/^-//;s/-$//'
}

# ============================================================================
# TYPE 1: SECTION FILES  (match N.M pattern — e.g. "2.1 Intro.txt")
# ============================================================================
if [[ "$PROCESS_TYPE" == "all" || "$PROCESS_TYPE" == "sections" ]]; then
    echo ""
    echo "══════════════════════════════════════════"
    echo "  TYPE 1: Section files (N.M pattern)"
    echo "══════════════════════════════════════════"

    # Find all files matching N.M at the start of their name
    SECTION_FILES_ALL=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            if echo "$fname" | grep -qE '^[0-9]+\.[0-9]+'; then echo "$f"; fi
          done) || true

    # Extract unique leading section integers
    SECTION_NUMBERS=$(echo "$SECTION_FILES_ALL" \
        | while IFS= read -r f; do
            basename "$f" | grep -oE '^[0-9]+'
          done \
        | sort -un) || true

    if [[ -z "$SECTION_NUMBERS" ]]; then
        echo "ℹ️  No N.M-style section files found."
    else
        TOTAL=$(echo "$SECTION_NUMBERS" | wc -l | tr -d ' ')
        echo "📚 Found $TOTAL sections."

        while IFS= read -r SECTION_NUM; do
            (( SECTION_NUM < START_SECTION )) && {
                echo "⏭️  SKIP  Section $SECTION_NUM (below --start-section $START_SECTION)"
                (( SKIPPED++ )) || true
                continue
            }

            # Collect all files for this section number
            SECTION_FILES=$(echo "$SECTION_FILES_ALL" \
                | while IFS= read -r f; do
                    fname=$(basename "$f")
                    leading=$(echo "$fname" | grep -oE '^[0-9]+')
                    [[ "$leading" == "$SECTION_NUM" ]] && echo "$f"
                  done) || true

            [[ -z "$SECTION_FILES" ]] && {
                echo "⚠️  WARN  Section $SECTION_NUM — no files found. Skipping."
                continue
            }

            # Derive title from the first file: strip "N.M " prefix
            FIRST=$(basename "$(echo "$SECTION_FILES" | head -1)")
            TITLE=$(slugify "$(echo "$FIRST" | sed -E 's/^[0-9]+\.[0-9]+[[:space:]]*//')")
            [[ -z "$TITLE" ]] && TITLE="section"

            PADDED=$(printf "%02d" "$SECTION_NUM")
            OUTPUT_FILE="$OUTPUT_DIR/section-${PADDED}-${TITLE}.md"

            if [[ -f "$OUTPUT_FILE" ]]; then
                echo "✅ SKIP  Section $SECTION_NUM → $(basename "$OUTPUT_FILE") (exists)"
                (( SKIPPED++ )) || true
                continue
            fi

            FILE_COUNT=$(echo "$SECTION_FILES" | wc -l | tr -d ' ')
            echo "⏳ START Section $SECTION_NUM ($FILE_COUNT files) → $(basename "$OUTPUT_FILE")"

            TRANSCRIPTS=""
            while IFS= read -r fpath; do
                TRANSCRIPTS+="$(cat "$fpath")"$'\n\n---\n\n'
            done <<< "$SECTION_FILES"

            PROMPT="You are creating a GitHub Flavored Markdown study guide for one section of a training course.

WORKFLOW INSTRUCTIONS:
${INSTRUCTIONS}

MODEL ID: ${MODEL_ID}

YOUR TASK:
- Process ONLY Section ${SECTION_NUM}.
- Read ALL transcripts below before writing.
- Follow the workflow instructions above.
- The model id to use in the <summary> tag is: ${MODEL_ID}
- Output ONLY the raw markdown. No preamble or explanation.

TRANSCRIPTS FOR SECTION ${SECTION_NUM}:
${TRANSCRIPTS}"

            call_claude "$PROMPT" "$OUTPUT_FILE" "Section $SECTION_NUM"

        done <<< "$SECTION_NUMBERS"
    fi
fi

# ============================================================================
# TYPE 2: INDIVIDUAL SESSION FILES  (everything that is NOT N.M pattern)
# ============================================================================
if [[ "$PROCESS_TYPE" == "all" || "$PROCESS_TYPE" == "sessions" ]]; then
    echo ""
    echo "══════════════════════════════════════════"
    echo "  TYPE 2: Individual session files"
    echo "══════════════════════════════════════════"

    SESSION_FILES=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            if ! echo "$fname" | grep -qE '^[0-9]+\.[0-9]+'; then echo "$f"; fi
          done) || true

    if [[ -z "$SESSION_FILES" ]]; then
        echo "ℹ️  No individual session files found."
    else
        SESSION_COUNT=$(echo "$SESSION_FILES" | wc -l | tr -d ' ')
        echo "📄 Found $SESSION_COUNT individual session files."

        while IFS= read -r f; do
            [[ -z "$f" ]] && continue
            fname=$(basename "$f")
            TITLE=$(slugify "$fname")
            OUTPUT_FILE="$OUTPUT_DIR/session-${TITLE}.md"

            if [[ -f "$OUTPUT_FILE" ]]; then
                echo "✅ SKIP  Session: $(basename "$OUTPUT_FILE") (exists)"
                (( SKIPPED++ )) || true
                continue
            fi

            echo "⏳ START Session: $fname"
            CONTENT=$(cat "$f")

            PROMPT="You are creating a GitHub Flavored Markdown study guide for one session of a training course.

WORKFLOW INSTRUCTIONS:
${INSTRUCTIONS}

MODEL ID: ${MODEL_ID}

YOUR TASK:
- Process the following transcript. Use the filename as the section title.
- Follow the workflow instructions above.
- The model id to use in the <summary> tag is: ${MODEL_ID}
- Output ONLY the raw markdown. No preamble or explanation.

FILENAME: ${fname}
TRANSCRIPT:
${CONTENT}"

            call_claude "$PROMPT" "$OUTPUT_FILE" "Session: $fname"

        done <<< "$SESSION_FILES"
    fi
fi

# ── Final Summary ──────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════"
echo "  ✅ Done:    $DONE"
echo "  ⏭  Skipped: $SKIPPED"
echo "  ❌ Failed:  $FAILED"
echo "═══════════════════════════════════"
