#!/bin/bash
# process_sections.sh — Group and process transcript files by section number (N.M pattern).
#
# Use this for Udemy-style courses where files are named like:
#   "2.1 Introduction.txt", "2.2 Concepts.txt", "3.1 Joins.txt"
# Files sharing the same leading integer are grouped into one study guide.
#
# Output:
#   All 2.x files → section-02-introduction.md
#   All 3.x files → section-03-joins.md
#
# Usage:
#   bash process_sections.sh \
#     --transcripts "/path/to/transcript-folder" \
#     --output      "/path/to/output-folder" \
#     --instructions "/path/to/Study_Guide_Workflow_Instructions.md" \
#     --model-id    "G3PCS46"
#
# Options:
#   --start-section N   Skip sections below N (resume support, default: 1)
#   --sleep N           Seconds between API calls (default: 3)
#
# Prerequisites: claude CLI installed and authenticated.
# Resume safety: existing output files are automatically skipped.

set -uo pipefail

# ── Parse arguments ────────────────────────────────────────────────────────────
TRANSCRIPT_DIR=""
OUTPUT_DIR=""
INSTRUCTIONS_FILE=""
MODEL_ID="G3PCS46"
SLEEP_BETWEEN=3
START_SECTION=1

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

[[ ! -d "$TRANSCRIPT_DIR" ]]  && { echo "❌ Transcript dir not found: $TRANSCRIPT_DIR"; exit 1; }
[[ ! -f "$INSTRUCTIONS_FILE" ]] && { echo "❌ Instructions file not found: $INSTRUCTIONS_FILE"; exit 1; }
mkdir -p "$OUTPUT_DIR"
command -v claude &>/dev/null || { echo "❌ 'claude' CLI not found. Install: npm install -g @anthropic-ai/claude-cli"; exit 1; }

INSTRUCTIONS=$(cat "$INSTRUCTIONS_FILE")
DONE=0; SKIPPED=0; FAILED=0

# ── Discover section numbers (files matching N.M at start of filename) ─────────
echo "🔍 Scanning: $TRANSCRIPT_DIR"

SECTION_NUMBERS=$(
    find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            if echo "$fname" | grep -qE '^[0-9]+\.[0-9]+'; then
                echo "$fname" | grep -oE '^[0-9]+'
            fi
          done \
        | sort -un
) || true

if [[ -z "$SECTION_NUMBERS" ]]; then
    echo "❌ No N.M-style files found (e.g. '2.1 Title.txt')."
    echo "   Use process_sessions.sh instead for files without this pattern."
    exit 1
fi

TOTAL=$(echo "$SECTION_NUMBERS" | wc -l | tr -d ' ')
echo "📚 Found $TOTAL sections to process."
echo ""

# ── Process each section ──────────────────────────────────────────────────────
while IFS= read -r SECTION_NUM; do
    if (( SECTION_NUM < START_SECTION )); then
        echo "⏭️  SKIP  Section $SECTION_NUM (below --start-section $START_SECTION)"
        (( SKIPPED++ )) || true
        continue
    fi

    # Collect all files for this section
    SECTION_FILES=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 \
        | sort -z | tr '\0' '\n' \
        | while IFS= read -r f; do
            fname=$(basename "$f")
            leading=$(echo "$fname" | grep -oE '^[0-9]+\.[0-9]+' | grep -oE '^[0-9]+' || true)
            [[ "$leading" == "$SECTION_NUM" ]] && echo "$f"
          done) || true

    if [[ -z "$SECTION_FILES" ]]; then
        echo "⚠️  WARN  Section $SECTION_NUM — no files found. Skipping."
        continue
    fi

    # Title from first file: strip "N.M " prefix
    FIRST=$(basename "$(echo "$SECTION_FILES" | head -1)")
    TITLE=$(echo "$FIRST" \
        | sed -E 's/^[0-9]+\.[0-9]+[[:space:]]*//' \
        | sed 's/\.txt$//' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\+/-/g' \
        | sed 's/^-//;s/-$//')
    [[ -z "$TITLE" ]] && TITLE="section"

    PADDED=$(printf "%02d" "$SECTION_NUM")
    OUTPUT_FILE="$OUTPUT_DIR/section-${PADDED}-${TITLE}.md"

    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "✅ SKIP  Section $SECTION_NUM → $(basename "$OUTPUT_FILE") (already exists)"
        (( SKIPPED++ )) || true
        continue
    fi

    FILE_COUNT=$(echo "$SECTION_FILES" | wc -l | tr -d ' ')
    echo "⏳ START Section $SECTION_NUM ($FILE_COUNT files) → $(basename "$OUTPUT_FILE")"

    # Concatenate all transcripts for this section
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

    RESULT=$(echo "$PROMPT" | claude 2>&1) || RESULT=""
    EXIT_CODE=$?

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
        [[ -n "$RESULT" ]] && echo "$RESULT" | head -3
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

