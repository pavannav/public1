#!/usr/bin/env node
/**
 * md_to_docx.js — Convert a Markdown file into a styled Word (.docx) document.
 *
 * Usage:
 *   node md_to_docx.js <input.md> <output.docx> [--diagrams-dir <dir>]
 *
 * Supports:
 *   - Headings (#, ##, ###, ####) incl. inline **bold** and emoji stripping
 *   - **bold**, `inline code`
 *   - Bullet lists (-, *) and numbered lists (1.)
 *   - ✅ / ❌ / ⚠ items rendered as colored checkmarks
 *   - Fenced code blocks ``` ``` with special handling for:
 *       - ```diff      -> red/green colored lines
 *       - ```mermaid   -> embedded as an image (see Mermaid handling below)
 *       - anything else -> plain monospace code block
 *   - GitHub-style callouts: > [!IMPORTANT] / [!NOTE] / [!WARNING] / [!TIP]
 *   - Markdown tables
 *   - Horizontal rules (---)
 *
 * Mermaid diagram handling:
 *   This environment has no headless browser, so Mermaid CANNOT be rendered
 *   via mermaid-cli/puppeteer. Instead, this script expects PRE-RENDERED PNG
 *   images for each ```mermaid block, in the order they appear in the source
 *   file, inside --diagrams-dir (default: ./diagrams), named:
 *       diagram1.png, diagram2.png, diagram3.png, ...
 *   See references/mermaid-diagrams.md in this skill for how to produce them
 *   (hand-authored SVG -> PNG via `sharp`, since no network access to
 *   download a headless browser is typically available).
 *   If a corresponding PNG is missing, the script falls back to rendering
 *   the raw mermaid source as a plain code block so nothing is silently lost.
 */

const path = require('path');
const fs = require('fs');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  HeadingLevel, AlignmentType, LevelFormat, BorderStyle, WidthType,
  ShadingType, ImageRun
} = require('docx');

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------
const args = process.argv.slice(2);
if (args.length < 2 || args.includes('--help') || args.includes('-h')) {
  console.log(`Usage: node md_to_docx.js <input.md> <output.docx> [--diagrams-dir <dir>]`);
  process.exit(args.includes('--help') || args.includes('-h') ? 0 : 1);
}
const INPUT_MD = args[0];
const OUTPUT_DOCX = args[1];
let DIAGRAMS_DIR = path.join(path.dirname(OUTPUT_DOCX), 'diagrams');
const diagFlagIdx = args.indexOf('--diagrams-dir');
if (diagFlagIdx !== -1 && args[diagFlagIdx + 1]) {
  DIAGRAMS_DIR = args[diagFlagIdx + 1];
}

if (!fs.existsSync(INPUT_MD)) {
  console.error(`Input file not found: ${INPUT_MD}`);
  process.exit(1);
}

// ---------------------------------------------------------------------------
// Palette
// ---------------------------------------------------------------------------
const BLUE = "2E75B6";
const DARK_BLUE = "1F4E79";
const LIGHT_BLUE = "D5E8F0";
const GREEN = "70AD47";
const LIGHT_GREEN = "E2EFDA";
const RED = "C00000";
const LIGHT_RED = "FCE4D6";
const YELLOW_BG = "FFF2CC";
const ORANGE = "ED7D31";
const GRAY = "595959";
const CODE_BG = "F5F5F5";

const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };
const noBorder = { style: BorderStyle.NONE, size: 0, color: "FFFFFF" };
const noBorders = { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder };

// IMPORTANT: keep this range tight (pictographic blocks only). \p{Emoji} in
// JS regex also matches plain ASCII digits 0-9, which silently eats section
// numbers like "1." from headings such as "#### 1. **Private API**".
const EMOJI_RE = /[\u{1F300}-\u{1FFFF}\u{2600}-\u{27BF}]/gu;

// ---------------------------------------------------------------------------
// Heading helpers
// ---------------------------------------------------------------------------
function cleanHeading(text) {
  return text
    .replace(/^#+\s*/, '')
    .replace(/\*\*/g, '')
    .replace(/`/g, '')
    .replace(EMOJI_RE, '')
    .trim();
}

function h1(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 360, after: 120 },
    children: [new TextRun({ text: cleanHeading(text), bold: true, size: 36, font: "Arial", color: DARK_BLUE })]
  });
}
function h2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 280, after: 100 },
    children: [new TextRun({ text: cleanHeading(text), bold: true, size: 28, font: "Arial", color: BLUE })]
  });
}
function h3(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 200, after: 80 },
    children: [new TextRun({ text: cleanHeading(text), bold: true, size: 24, font: "Arial", color: "404040" })]
  });
}
function h4(text) {
  return new Paragraph({
    spacing: { before: 160, after: 60 },
    children: [new TextRun({ text: cleanHeading(text), bold: true, size: 22, font: "Arial", color: GRAY })]
  });
}

// ---------------------------------------------------------------------------
// Inline parsing (bold / inline code)
// ---------------------------------------------------------------------------
function parseInline(text) {
  const runs = [];
  const parts = text.split(/(\*\*[^*]+\*\*|`[^`]+`)/);
  for (const part of parts) {
    if (part.startsWith('**') && part.endsWith('**')) {
      runs.push(new TextRun({ text: part.slice(2, -2), bold: true, font: "Arial", size: 22 }));
    } else if (part.startsWith('`') && part.endsWith('`')) {
      runs.push(new TextRun({
        text: part.slice(1, -1), font: "Courier New", size: 22, color: "C7254E",
        shading: { fill: "F9F2F4", type: ShadingType.CLEAR }
      }));
    } else if (part) {
      runs.push(new TextRun({ text: part, font: "Arial", size: 22 }));
    }
  }
  return runs;
}

function bodyPara(text, opts = {}) {
  const cleaned = text
    .replace(/^[-*]\s+/, '')
    .replace(/✅\s?/g, '✅ ')
    .replace(/❌\s?/g, '❌ ')
    .replace(/⚠\s?/g, '⚠ ');
  return new Paragraph({ spacing: { before: 60, after: 60 }, ...opts, children: parseInline(cleaned) });
}

function bulletPara(text, level = 0, ref = "bullets") {
  const cleaned = text.replace(/^[-*✅❌⚠]\s+/, '').replace(/✅\s?/g, '').replace(/❌\s?/g, '').replace(/⚠\s?/g, '');
  return new Paragraph({
    numbering: { reference: ref, level },
    spacing: { before: 40, after: 40 },
    children: parseInline(cleaned)
  });
}

// ---------------------------------------------------------------------------
// Code blocks (with diff coloring)
// ---------------------------------------------------------------------------
function codeBlock(lines, isDiff = false) {
  const rows = lines.map(line => {
    let color = "333333";
    let bg = CODE_BG;
    if (isDiff) {
      if (line.startsWith('+')) { color = "276221"; bg = "EAFFEA"; }
      else if (line.startsWith('-')) { color = "9B1C1C"; bg = "FFEEEE"; }
      else if (line.startsWith('!')) { color = "7D4E00"; bg = "FFF9E6"; }
    }
    return new TableRow({
      children: [new TableCell({
        borders: noBorders,
        width: { size: 9360, type: WidthType.DXA },
        margins: { top: 0, bottom: 0, left: 120, right: 120 },
        shading: { fill: bg, type: ShadingType.CLEAR },
        children: [new Paragraph({
          spacing: { before: 0, after: 0 },
          children: [new TextRun({ text: line || ' ', font: "Courier New", size: 22, color })]
        })]
      })]
    });
  });
  return new Table({
    width: { size: 9360, type: WidthType.DXA },
    columnWidths: [9360],
    borders: {
      top: { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" },
      bottom: { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" },
      left: { style: BorderStyle.SINGLE, size: 4, color: BLUE },
      right: { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" },
      insideH: noBorder, insideV: noBorder
    },
    rows
  });
}

// ---------------------------------------------------------------------------
// Mermaid -> pre-rendered image embedding
// ---------------------------------------------------------------------------
function mermaidImage(pngPath) {
  const sizeOf = require('./lib/png-size'); // tiny local helper, see below
  const { width: pxWidth, height: pxHeight } = sizeOf(pngPath);
  const maxWidthIn = 6.5;
  const maxHeightIn = 7.5;
  const aspect = pxHeight / pxWidth;
  let widthIn = maxWidthIn;
  let heightIn = widthIn * aspect;
  if (heightIn > maxHeightIn) {
    heightIn = maxHeightIn;
    widthIn = heightIn / aspect;
  }
  const imageData = fs.readFileSync(pngPath);
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 120, after: 120 },
    children: [new ImageRun({
      data: imageData,
      transformation: { width: Math.round(widthIn * 96), height: Math.round(heightIn * 96) },
      type: "png"
    })]
  });
}

// ---------------------------------------------------------------------------
// Callouts
// ---------------------------------------------------------------------------
function calloutBox(text, type) {
  const configs = {
    'IMPORTANT': { color: RED, bg: LIGHT_RED, label: '⚑ IMPORTANT' },
    'NOTE': { color: BLUE, bg: LIGHT_BLUE, label: 'ℹ NOTE' },
    'WARNING': { color: ORANGE, bg: YELLOW_BG, label: '⚠ WARNING' },
    'TIP': { color: GREEN, bg: LIGHT_GREEN, label: '💡 TIP' }
  };
  const cfg = configs[type] || configs['NOTE'];
  return new Table({
    width: { size: 9360, type: WidthType.DXA },
    columnWidths: [9360],
    borders: {
      top: { style: BorderStyle.SINGLE, size: 1, color: cfg.color },
      bottom: { style: BorderStyle.SINGLE, size: 1, color: cfg.color },
      left: { style: BorderStyle.SINGLE, size: 6, color: cfg.color },
      right: { style: BorderStyle.SINGLE, size: 1, color: cfg.color },
      insideH: noBorder, insideV: noBorder
    },
    rows: [new TableRow({ children: [new TableCell({
      borders: noBorders,
      width: { size: 9360, type: WidthType.DXA },
      margins: { top: 60, bottom: 60, left: 160, right: 160 },
      shading: { fill: cfg.bg, type: ShadingType.CLEAR },
      children: [
        new Paragraph({ spacing: { before: 0, after: 40 }, children: [new TextRun({ text: cfg.label, bold: true, font: "Arial", size: 20, color: cfg.color })] }),
        new Paragraph({ spacing: { before: 0, after: 0 }, children: parseInline(text.trim()) })
      ]
    })] })]
  });
}

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------
function mdTable(lines) {
  const rows = lines.filter(l => !l.match(/^\s*\|[-:| ]+\|\s*$/));
  if (rows.length === 0) return null;
  const parseRow = (line) => line.replace(/^\||\|$/g, '').split('|').map(c => c.trim());
  const header = parseRow(rows[0]);
  const dataRows = rows.slice(1);
  const colCount = header.length;
  const colWidth = Math.floor(9360 / colCount);
  const colWidths = Array(colCount).fill(colWidth);

  const headerRow = new TableRow({
    tableHeader: true,
    children: header.map((cell, i) => new TableCell({
      borders,
      width: { size: colWidths[i], type: WidthType.DXA },
      margins: { top: 80, bottom: 80, left: 120, right: 120 },
      shading: { fill: BLUE, type: ShadingType.CLEAR },
      children: [new Paragraph({ alignment: AlignmentType.CENTER, children: [new TextRun({ text: cell, bold: true, font: "Arial", size: 20, color: "FFFFFF" })] })]
    }))
  });

  const dataTableRows = dataRows.map((line, ri) => {
    const cells = parseRow(line);
    const isAlt = ri % 2 === 1;
    return new TableRow({
      children: cells.map((cell, i) => {
        const c = i < colWidths.length ? colWidths[i] : colWidth;
        const cleaned = cell.replace(/✅/g, '✓').replace(/❌/g, '✗').replace(/⚠/g, '⚠');
        const isGreen = cleaned.includes('✓');
        const isRed = cleaned.includes('✗');
        return new TableCell({
          borders,
          width: { size: c, type: WidthType.DXA },
          margins: { top: 60, bottom: 60, left: 120, right: 120 },
          shading: { fill: isAlt ? "F7FBFF" : "FFFFFF", type: ShadingType.CLEAR },
          children: [new Paragraph({ children: [new TextRun({ text: cleaned, font: "Arial", size: 20, color: isGreen ? GREEN : isRed ? RED : undefined })] })]
        });
      })
    });
  });

  return new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: colWidths, rows: [headerRow, ...dataTableRows] });
}

function horizontalRule() {
  return new Paragraph({
    spacing: { before: 200, after: 200 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 3, color: "CCCCCC", space: 1 } },
    children: []
  });
}

// ---------------------------------------------------------------------------
// Main parse
// ---------------------------------------------------------------------------
const raw = fs.readFileSync(INPUT_MD, 'utf8').replace(/\r\n/g, '\n');
const lines = raw.split('\n');

const elements = [];
let i = 0;
let mermaidCounter = 0;

const numbering = {
  config: [
    { reference: "bullets", levels: [
      { level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 720, hanging: 360 } } } },
      { level: 1, format: LevelFormat.BULLET, text: "◦", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 1080, hanging: 360 } } } },
    ]},
    { reference: "numbers", levels: [
      { level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 720, hanging: 360 } } } },
    ]}
  ]
};

while (i < lines.length) {
  const line = lines[i];

  if (line.match(/^# /)) { elements.push(h1(line)); i++; continue; }
  if (line.match(/^## /)) { elements.push(h2(line)); i++; continue; }
  if (line.match(/^### /)) { elements.push(h3(line)); i++; continue; }
  if (line.match(/^#### /)) { elements.push(h4(line)); i++; continue; }

  if (line.match(/^---+\s*$/)) { elements.push(horizontalRule()); i++; continue; }

  // GitHub-style callouts
  if (line.match(/^>\s*\[!(IMPORTANT|NOTE|WARNING|TIP)\]/)) {
    const type = line.match(/\[!(\w+)\]/)[1];
    const textLines = [];
    i++;
    while (i < lines.length && lines[i].startsWith('>')) {
      const content = lines[i].replace(/^>\s?/, '').trim();
      if (content) textLines.push(content);
      i++;
    }
    elements.push(calloutBox(textLines.join(' '), type));
    elements.push(new Paragraph({ spacing: { before: 100, after: 0 }, children: [] }));
    continue;
  }

  // Plain blockquote (treated as a NOTE callout)
  if (line.match(/^>\s+/)) {
    const textLines = [];
    while (i < lines.length && lines[i].match(/^>\s*/)) {
      const content = lines[i].replace(/^>\s?/, '').trim();
      if (content && !content.match(/^\[!/)) textLines.push(content);
      i++;
    }
    if (textLines.length > 0) {
      elements.push(calloutBox(textLines.join(' '), 'NOTE'));
      elements.push(new Paragraph({ spacing: { before: 80, after: 0 }, children: [] }));
    }
    continue;
  }

  // Fenced code blocks
  if (line.match(/^```/)) {
    const lang = line.replace(/^```/, '').trim().toLowerCase();
    const isDiff = lang === 'diff';
    const isMermaid = lang === 'mermaid';
    const codeLines = [];
    i++;
    while (i < lines.length && !lines[i].match(/^```/)) { codeLines.push(lines[i]); i++; }
    i++; // skip closing fence

    if (isMermaid) {
      mermaidCounter++;
      const candidate = path.join(DIAGRAMS_DIR, `diagram${mermaidCounter}.png`);
      if (fs.existsSync(candidate)) {
        elements.push(mermaidImage(candidate));
      } else {
        console.warn(`WARNING: no pre-rendered image found for mermaid block #${mermaidCounter} (expected ${candidate}). Falling back to raw text.`);
        elements.push(codeBlock(codeLines));
      }
      elements.push(new Paragraph({ spacing: { before: 80, after: 0 }, children: [] }));
    } else if (codeLines.length > 0) {
      elements.push(codeBlock(codeLines, isDiff));
      elements.push(new Paragraph({ spacing: { before: 80, after: 0 }, children: [] }));
    }
    continue;
  }

  // Markdown tables
  if (line.match(/^\|/) && lines[i + 1] && lines[i + 1].match(/^\|[-: |]+\|/)) {
    const tableLines = [];
    while (i < lines.length && lines[i].match(/^\|/)) { tableLines.push(lines[i]); i++; }
    const tbl = mdTable(tableLines);
    if (tbl) { elements.push(tbl); elements.push(new Paragraph({ spacing: { before: 100, after: 0 }, children: [] })); }
    continue;
  }

  // Bullet list items (incl. ✅ / ❌ as colored checkmarks)
  if (line.match(/^[-*]\s+/) || line.match(/^✅/) || line.match(/^❌/)) {
    const text = line.replace(/^[-*]\s+/, '').trim();
    const hasCheck = line.includes('✅');
    const hasCross = line.includes('❌');
    if (hasCheck || hasCross) {
      const prefix = hasCheck ? '✓  ' : '✗  ';
      const color = hasCheck ? GREEN : RED;
      const cleaned = text.replace(/✅\s?/g, '').replace(/❌\s?/g, '').trim();
      elements.push(new Paragraph({
        spacing: { before: 40, after: 40 },
        indent: { left: 360 },
        children: [new TextRun({ text: prefix, bold: true, font: "Arial", size: 22, color }), ...parseInline(cleaned)]
      }));
    } else {
      elements.push(bulletPara(text, 0, "bullets"));
    }
    i++;
    continue;
  }

  // Numbered list items
  if (line.match(/^\d+\.\s+/)) {
    const text = line.replace(/^\d+\.\s+/, '').trim();
    elements.push(bulletPara(text, 0, "numbers"));
    i++;
    continue;
  }

  // Blank line
  if (line.trim() === '') { elements.push(new Paragraph({ spacing: { before: 40, after: 40 }, children: [] })); i++; continue; }

  // Regular paragraph
  elements.push(bodyPara(line));
  i++;
}

if (mermaidCounter > 0) {
  console.log(`Found ${mermaidCounter} mermaid block(s). Looked for pre-rendered PNGs in: ${DIAGRAMS_DIR}`);
}

const doc = new Document({
  numbering,
  styles: {
    default: { document: { run: { font: "Arial", size: 22 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 36, bold: true, font: "Arial", color: DARK_BLUE },
        paragraph: { spacing: { before: 360, after: 120 }, outlineLevel: 0,
          border: { bottom: { style: BorderStyle.SINGLE, size: 3, color: BLUE, space: 4 } } } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 28, bold: true, font: "Arial", color: BLUE },
        paragraph: { spacing: { before: 280, after: 100 }, outlineLevel: 1 } },
      { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 24, bold: true, font: "Arial", color: "404040" },
        paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 2 } },
    ]
  },
  sections: [{
    properties: { page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
    children: elements
  }]
});

Packer.toBuffer(doc).then(buffer => {
  fs.mkdirSync(path.dirname(OUTPUT_DOCX), { recursive: true });
  fs.writeFileSync(OUTPUT_DOCX, buffer);
  console.log(`Done! Wrote ${OUTPUT_DOCX}`);
}).catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
