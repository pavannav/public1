---
name: md-to-docx
description: Convert a Markdown file (especially technical/course-style notes with headings, code blocks, tables, GitHub-style callouts like [!NOTE]/[!IMPORTANT]/[!WARNING]/[!TIP], checkmark bullets, diff blocks, and Mermaid diagrams) into a polished, professionally styled Word (.docx) document. Use this skill whenever the user asks to convert, export, or "turn into Word/.docx" a markdown file, especially when the source has rich formatting beyond plain text — code blocks, tables, callout boxes, or mermaid diagrams. Also use it as a reference when the user wants the SAME visual style applied to another markdown file they upload later in the conversation.
---

# Markdown to Word (.docx) Converter

Converts Markdown into a styled `.docx` using the `docx` npm library, with a
deliberate color palette and layout (not Word's default plain styling).
Handles the GitHub-Flavored-Markdown features that plain pandoc-style
conversion tends to mangle: callout admonitions, diff-colored code blocks,
and Mermaid diagrams (which Word cannot render natively).

## When to use this

- User uploads a `.md` file and asks for a Word/docx version.
- User asks to "convert this markdown to Word" or similar.
- User wants consistent styling applied across multiple markdown files in
  the same conversation/session (re-run the same script on each file).

## Quick start

```bash
# 1. Install the one dependency
npm install docx

# 2. Run the converter
node scripts/md_to_docx.js <input.md> <output.docx>
```

That's it for files with no Mermaid diagrams. If the source has
` ```mermaid ` blocks, see **Step 2: Mermaid diagrams** below — those need
one extra step before running the converter.

## Output style (what you get)

- **Headings**: H1 dark-blue with bottom border, H2 medium-blue, H3 dark
  gray, H4 bold gray — sized 18/14/12/11pt. Numbered headings like
  `#### 1. **Private API**` keep their number; `**bold**`, `` `code` ``, and
  emoji markers are stripped from heading text (emoji decorate the source
  but add nothing in print).
- **Code blocks**: light-gray shaded box, left blue accent border, 11pt
  Courier New. ` ```diff ` blocks get per-line coloring: `-` lines red,
  `+` lines green, `!` lines amber — matches how GitHub renders diffs.
- **Callouts**: `> [!IMPORTANT]`, `> [!NOTE]`, `> [!WARNING]`, `> [!TIP]`
  each render as a colored, left-bordered box (red/blue/orange/green
  respectively) with a bold label line. Plain `>` blockquotes (no `[!TYPE]`)
  fall back to the NOTE style.
- **Checkmarks**: `✅`/`❌` list items and bullets render as bold colored
  ✓/✗ glyphs (green/red) instead of raw emoji, which print inconsistently.
- **Tables**: blue header row with white bold text, zebra-striped body rows,
  thin gray borders.
- **Mermaid diagrams**: embedded as actual images (see below) — NOT dumped
  as raw mermaid syntax text, which is unreadable to a non-technical reader.

## Step 1: Run the basic conversion

```bash
node scripts/md_to_docx.js /path/to/input.md /path/to/output.docx
```

This handles everything except Mermaid diagrams in one pass — headings,
bold/inline code, bullet/numbered lists, code blocks (including diff
coloring), tables, callouts, horizontal rules.

If the source has NO ` ```mermaid ` blocks, you're done — present the file
to the user.

## Step 2: Mermaid diagrams (if present)

**Word cannot render Mermaid syntax.** Check first whether a real renderer
is available in your environment:

```bash
# Try this first — it may just work if you have network/browser access
npm install -g @mermaid-js/mermaid-cli
mmdc -i diagram.mmd -o diagram.png
```

If that fails (no network access to fetch headless Chromium, which is the
common case in sandboxed tool environments), use the **hand-authored SVG
fallback** — see `references/mermaid-diagrams.md` for the full recipe and
patterns for flowcharts and sequence diagrams. Summary:

1. Extract each ` ```mermaid ` block from the source, in order.
2. For each one, hand-write an equivalent plain SVG (boxes, arrows, text —
   see the reference doc for flowchart and sequence-diagram patterns).
3. Rasterize each SVG to PNG:
   ```bash
   npm install sharp
   node scripts/render_svg.js diagram.svg diagrams/diagram1.png
   ```
4. Name the PNGs `diagram1.png`, `diagram2.png`, `diagram3.png`, ... in
   the SAME ORDER the mermaid blocks appear in the source file, all inside
   one folder (default: `diagrams/` next to the output docx, or pass
   `--diagrams-dir <path>`).
5. Re-run the converter — it auto-detects mermaid blocks, looks up the
   matching numbered PNG, and embeds it sized to fit the page width:
   ```bash
   node scripts/md_to_docx.js input.md output.docx --diagrams-dir diagrams/
   ```
6. **Always preview each rendered PNG with the image-viewing tool before
   embedding** — check label placement, arrow direction, and that nothing
   overlaps. Iterate on the SVG directly; these are quick to fix.

If a mermaid block has no matching PNG when the converter runs, it falls
back to printing the raw mermaid source as a plain code block (with a
console warning) rather than silently dropping content.

## Common pitfalls (already fixed in this script, but worth knowing)

- **Don't strip digits when cleaning heading emoji.** A regex like
  `\p{Emoji}` in JavaScript also matches plain ASCII digits 0-9, so naive
  emoji-stripping on a heading like `#### 1. **Private API**` deletes the
  "1." section number. This script uses a tight Unicode range
  (`\u{1F300}-\u{1FFFF}`, `\u{2600}-\u{27BF}`) that only matches actual
  pictographic characters.
- **Don't leave `**bold**` markers as literal asterisks in headings.**
  Markdown headings often contain inline bold (`#### 1. **Private API**`);
  strip `**` and render the whole heading bold via the paragraph style
  instead of leaving the markdown syntax visible.
- **Diff blocks need explicit language detection.** A plain ` ``` ` fence
  with no language tag should NOT get diff coloring — only ` ```diff `
  should. Don't infer diff-ness from `+`/`-` prefixes alone, since YAML,
  CLI output, and ASCII diagrams also use leading dashes.
- **Font sizes in the `docx` library are in half-points.** 11pt body/code
  text = `size: 22`, not `11`. Easy to get backwards.

## Customizing the style

All colors and the palette are defined as constants near the top of
`scripts/md_to_docx.js` (`BLUE`, `DARK_BLUE`, `GREEN`, `RED`, `ORANGE`,
etc.). Change them once and every element (headings, callouts, code blocks,
tables) picks up the new palette automatically. Font size is controlled by
`size:` values throughout (half-points — divide the desired pt size by, er,
multiply by 2).

## Files in this skill

```
md-to-docx/
├── SKILL.md                          (this file)
├── scripts/
│   ├── md_to_docx.js                 (main converter — run this)
│   ├── render_svg.js                 (SVG -> PNG rasterizer for mermaid fallback)
│   └── lib/png-size.js               (tiny dependency-free PNG dimension reader)
└── references/
    └── mermaid-diagrams.md           (how to hand-author mermaid as SVG)
```
