#!/bin/bash
# process_course.sh — Generic study guide generator for ANY course.
#
# Usage:
#   ./process_course.sh \
#     --transcripts "/path/to/transcripts/course-folder" \
#     --output      "/path/to/output/folder" \
#     --instructions "/path/to/Study_Guide_Workflow_Instructions.md" \
#     --model-id    "G3PCS46"
#
# Example (SQL course):
#   ./process_course.sh \
#     --transcripts "/mnt/z/sharefolder/Transcripts/All-Transcripts/Udemy-Transcripts/the-complete-sql-bootcamp-30-hours-go-from-zero-to-hero-Baraa" \
#     --output      "/mnt/z/sharefolder/Transcripts/StudyGuides/SQL-30-hours-Baraa/G3PCS46" \
#     --instructions "/mnt/z/sharefolder/Transcripts/StudyGuides/1-Prompts/Study_Guide_Workflow_Instructions.md" \
#     --model-id    "G3PCS46"
#
# How it discovers sections:
#   - Scans the transcript folder for all .txt files
#   - Groups files by their leading integer prefix  (e.g., "5." for "5.1 Foo.txt", "5.2 Bar.txt")
#   - Processes each group as one section — no hardcoding needed
#
# Prerequisites:
#   - Claude CLI installed: npm install -g @anthropic-ai/claude-cli
#   - Authenticated:        claude auth
#
# Resume safety:
#   - If an output file already exists it is skipped automatically.
#   - Safe to re-run after a crash or timeout.

set -uo pipefail   # no -e: grep exits 1 on no-match, which would kill the script with -e

# ── Parse arguments ────────────────────────────────────────────────────────────
TRANSCRIPT_DIR=""
OUTPUT_DIR=""
INSTRUCTIONS_FILE=""
MODEL_ID="G3PCS46"
SLEEP_BETWEEN=3         # seconds between API calls
START_SECTION=1         # skip sections below this number (useful to resume)

while [[ $# -gt 0 ]]; do
    case "$1" in
        --transcripts)   TRANSCRIPT_DIR="$2";   shift 2 ;;
        --output)        OUTPUT_DIR="$2";        shift 2 ;;
        --instructions)  INSTRUCTIONS_FILE="$2"; shift 2 ;;
        --model-id)      MODEL_ID="$2";          shift 2 ;;
        --start-section) START_SECTION="$2";     shift 2 ;;
        --sleep)         SLEEP_BETWEEN="$2";     shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

# ── Validate ───────────────────────────────────────────────────────────────────
if [[ -z "$TRANSCRIPT_DIR" || -z "$OUTPUT_DIR" || -z "$INSTRUCTIONS_FILE" ]]; then
    echo "Usage: $0 --transcripts DIR --output DIR --instructions FILE [--model-id ID] [--start-section N] [--sleep N]"
    exit 1
fi

if [[ ! -d "$TRANSCRIPT_DIR" ]]; then
    echo "❌ Transcript directory not found: $TRANSCRIPT_DIR"; exit 1
fi

if [[ ! -f "$INSTRUCTIONS_FILE" ]]; then
    echo "❌ Instructions file not found: $INSTRUCTIONS_FILE"; exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ── Check Claude CLI ───────────────────────────────────────────────────────────
if ! command -v claude &> /dev/null; then
    echo "❌ 'claude' CLI not found. Install with: npm install -g @anthropic-ai/claude-cli"
    exit 1
fi

INSTRUCTIONS=$(cat "$INSTRUCTIONS_FILE")

# ── Discover unique section numbers from filenames ────────────────────────────
# Extracts the FIRST number found in each filename — works for:
#   "5.1 Title.txt"          → 5
#   "Session-01-Title.txt"   → 1
#   "02-step-01-foo.txt"     → 2
echo "🔍 Scanning: $TRANSCRIPT_DIR"

SECTION_NUMBERS=$(
    find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z \
        | xargs -0 -I{} bash -c 'basename "$1" | grep -oE "[0-9]+" | head -1' _ {} \
        | sort -un \
    ) || true

if [[ -z "$SECTION_NUMBERS" ]]; then
    echo "❌ No transcript files found in $TRANSCRIPT_DIR"
    echo "   Expected files like: '1.1 Introduction.txt', '2.3 Topic.txt'"
    exit 1
fi

TOTAL=$(echo "$SECTION_NUMBERS" | wc -l | tr -d ' ')
echo "📚 Found $TOTAL sections to process."
echo ""

# ── Process each section ──────────────────────────────────────────────────────
DONE=0
SKIPPED=0
FAILED=0

while IFS= read -r SECTION_NUM; do
    # Skip sections before --start-section
    if (( SECTION_NUM < START_SECTION )); then
        echo "⏭️  SKIP  Section $SECTION_NUM (below --start-section $START_SECTION)"
        (( SKIPPED++ )) || true
        continue
    fi

    # Collect transcript files belonging to this section number (handles spaces + any prefix style)
    # Matches: "5.1 Title", "Session-05-Title", "05-step-01-Title", etc.
    SECTION_FILES=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 | \
        sort -z | tr '\0' '\n' | \
        grep -iE "/(session-|step-)?0*${SECTION_NUM}[. _-]") || true

    if [[ -z "$SECTION_FILES" ]]; then
        echo "⚠️  WARN  Section $SECTION_NUM — could not find transcript files. Skipping."
        continue
    fi

    # Derive a title from the first transcript filename (quote properly for spaces)
    FIRST_FILE=$(basename "$(echo "$SECTION_FILES" | head -1)")
    # Strip leading "N.M " or "N." prefix, strip .txt, lowercase, replace spaces/specials with -
    TITLE=$(echo "$FIRST_FILE" \
        | sed -E 's/^[Ss]ession-[0-9]+-?//' \
        | sed -E 's/^[0-9]+\.[0-9]+[[:space:]]*//' \
        | sed -E 's/^[0-9]+-?//' \
        | sed 's/\.txt$//' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\+/-/g' \
        | sed 's/^-//;s/-$//' \
        | sed -E 's/^step-?[0-9]+-?[0-9]*-//')
    [[ -z "$TITLE" ]] && TITLE="section"

    PADDED=$(printf "%02d" "$SECTION_NUM")
    OUTPUT_FILE="$OUTPUT_DIR/section-${PADDED}-${TITLE}.md"

    # Skip if output already exists
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "✅ SKIP  Section $SECTION_NUM → $(basename "$OUTPUT_FILE") (already exists)"
        (( SKIPPED++ )) || true
        continue
    fi

    # Concatenate all transcripts
    TRANSCRIPTS=""
    FILE_COUNT=0
    while IFS= read -r fpath; do
        TRANSCRIPTS+="$(cat "$fpath")"
        TRANSCRIPTS+=$'\n\n---\n\n'
        (( FILE_COUNT++ )) || true
    done <<< "$SECTION_FILES"

    echo "⏳ START Section $SECTION_NUM ($FILE_COUNT files) → $(basename "$OUTPUT_FILE")"

    # Build prompt
    PROMPT="You are creating a GitHub Flavored Markdown study guide for one section of a training course.

WORKFLOW INSTRUCTIONS:
${INSTRUCTIONS}

MODEL ID: ${MODEL_ID}

YOUR TASK:
- Process ONLY Section ${SECTION_NUM}.
- Read ALL transcripts provided below before writing anything.
- Write a single comprehensive study guide following the instructions above.
- The model id to use in the <summary> tag is: ${MODEL_ID}
- Output ONLY the markdown content. No preamble, no explanation — just the raw markdown.

TRANSCRIPTS FOR SECTION ${SECTION_NUM}:
${TRANSCRIPTS}"

    # Call Claude CLI — try piped input first, fall back to -p flag
    RESULT=$(echo "$PROMPT" | claude 2>&1) || RESULT=""
    EXIT_CODE=$?

    # If pipe failed, try -p flag syntax
    if [[ $EXIT_CODE -ne 0 || -z "$RESULT" ]]; then
        RESULT=$(claude -p "$PROMPT" 2>&1) || RESULT=""
        EXIT_CODE=$?
    fi

    if [[ $EXIT_CODE -eq 0 && -n "$RESULT" ]]; then
        echo "$RESULT" > "$OUTPUT_FILE"
        echo "✅ DONE  Section $SECTION_NUM → $(basename "$OUTPUT_FILE")"
        (( DONE++ )) || true
    else
        echo "❌ FAIL  Section $SECTION_NUM"
        [[ -n "$RESULT" ]] && echo "$RESULT" | head -5
        (( FAILED++ )) || true
    fi

    sleep "$SLEEP_BETWEEN"

done <<< "$SECTION_NUMBERS"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════"
echo "  ✅ Done:    $DONE"
echo "  ⏭  Skipped: $SKIPPED"
echo "  ❌ Failed:  $FAILED"
echo "═══════════════════════════════════"

