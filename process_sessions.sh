#!/bin/bash
# process_sessions.sh — Process each transcript file individually as its own study guide.
#
# Use this for courses where each file IS a session (no subsection grouping needed).
# Examples: RHCSA, AWS sessions, any folder where 1 file = 1 topic.
#
# Output files are named from the input filename (slugified):
#   "Session-01-Objective-of-RHCSA.txt" → "session-01-objective-of-rhcsa.md"
#   "Introduction.txt"                  → "introduction.md"
#   "Bonus-Content.txt"                 → "bonus-content.md"
#
# Usage:
#   bash process_sessions.sh \
#     --transcripts "/path/to/transcript-folder" \
#     --output      "/path/to/output-folder" \
#     --instructions "/path/to/Study_Guide_Workflow_Instructions.md" \
#     --model-id    "G3PCS46"
#
# Options:
#   --sleep N     Seconds between API calls (default: 3)
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

while [[ $# -gt 0 ]]; do
    case "$1" in
        --transcripts)   TRANSCRIPT_DIR="$2";   shift 2 ;;
        --output)        OUTPUT_DIR="$2";        shift 2 ;;
        --instructions)  INSTRUCTIONS_FILE="$2"; shift 2 ;;
        --model-id)      MODEL_ID="$2";          shift 2 ;;
        --sleep)         SLEEP_BETWEEN="$2";     shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

# ── Validate ───────────────────────────────────────────────────────────────────
if [[ -z "$TRANSCRIPT_DIR" || -z "$OUTPUT_DIR" || -z "$INSTRUCTIONS_FILE" ]]; then
    echo "Usage: $0 --transcripts DIR --output DIR --instructions FILE [--model-id ID] [--sleep N]"
    exit 1
fi

[[ ! -d "$TRANSCRIPT_DIR" ]]  && { echo "❌ Transcript dir not found: $TRANSCRIPT_DIR"; exit 1; }
[[ ! -f "$INSTRUCTIONS_FILE" ]] && { echo "❌ Instructions file not found: $INSTRUCTIONS_FILE"; exit 1; }
mkdir -p "$OUTPUT_DIR"
command -v claude &>/dev/null || { echo "❌ 'claude' CLI not found. Install: npm install -g @anthropic-ai/claude-cli"; exit 1; }

INSTRUCTIONS=$(cat "$INSTRUCTIONS_FILE")
DONE=0; SKIPPED=0; FAILED=0

echo "🔍 Scanning: $TRANSCRIPT_DIR"
TOTAL=$(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" | wc -l | tr -d ' ')
echo "📄 Found $TOTAL transcript files."
echo ""

# ── Process each file individually ────────────────────────────────────────────
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    fname=$(basename "$f")

    # Slugify filename → output name  (strips .txt, lowercases, replaces non-alphanumeric with -)
    SLUG=$(echo "$fname" \
        | sed 's/\.txt$//' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g' \
        | sed 's/-\+/-/g' \
        | sed 's/^-//;s/-$//')

    OUTPUT_FILE="$OUTPUT_DIR/${SLUG}.md"

    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "✅ SKIP  $(basename "$OUTPUT_FILE") (already exists)"
        (( SKIPPED++ )) || true
        continue
    fi

    echo "⏳ START $fname"

    CONTENT=$(cat "$f")
    PROMPT="You are creating a GitHub Flavored Markdown study guide for one session of a training course.

WORKFLOW INSTRUCTIONS:
${INSTRUCTIONS}

MODEL ID: ${MODEL_ID}

YOUR TASK:
- Process the transcript below. Use the filename as the section title.
- Follow the workflow instructions above.
- The model id to use in the <summary> tag is: ${MODEL_ID}
- Output ONLY the raw markdown. No preamble or explanation.

FILENAME: ${fname}
TRANSCRIPT:
${CONTENT}"

    RESULT=$(echo "$PROMPT" | claude 2>&1) || RESULT=""
    EXIT_CODE=$?

    if [[ $EXIT_CODE -ne 0 || -z "$RESULT" ]]; then
        RESULT=$(claude -p "$PROMPT" 2>&1) || RESULT=""
        EXIT_CODE=$?
    fi

    if [[ $EXIT_CODE -eq 0 && -n "$RESULT" ]]; then
        echo "$RESULT" > "$OUTPUT_FILE"
        echo "✅ DONE  $(basename "$OUTPUT_FILE")"
        (( DONE++ )) || true
    else
        echo "❌ FAIL  $fname"
        [[ -n "$RESULT" ]] && echo "$RESULT" | head -3
        (( FAILED++ )) || true
    fi

    sleep "$SLEEP_BETWEEN"

done < <(find "$TRANSCRIPT_DIR" -maxdepth 1 -name "*.txt" -print0 | sort -z | tr '\0' '\n')

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════"
echo "  ✅ Done:    $DONE"
echo "  ⏭  Skipped: $SKIPPED"
echo "  ❌ Failed:  $FAILED"
echo "═══════════════════════════════════"

