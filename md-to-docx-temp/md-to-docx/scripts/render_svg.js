#!/usr/bin/env node
/**
 * render_svg.js — Rasterize one or more hand-authored SVG diagrams to PNG
 * using the `sharp` library (pure Node, no headless browser required).
 *
 * Usage:
 *   node render_svg.js <input.svg> <output.png> [--scale 2] [--width W] [--height H]
 *
 * Why this exists:
 *   Mermaid's official renderers (mermaid-cli, kroki, mermaid.ink) all
 *   require either a headless browser (Puppeteer/Chromium) or outbound
 *   network access to a rendering service. Sandboxed environments often
 *   have neither. The reliable fallback is:
 *     1. Hand-translate the mermaid diagram into a plain SVG (see
 *        references/mermaid-diagrams.md for the recipe and node/edge
 *        layout conventions used in this skill).
 *     2. Rasterize that SVG to PNG with `sharp` (pure JS image library,
 *        installable via `npm install sharp` with no browser dependency).
 *     3. Embed the PNG into the Word doc with ImageRun (handled by
 *        md_to_docx.js automatically, given diagram1.png, diagram2.png, ...
 *        in the --diagrams-dir).
 */
const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const args = process.argv.slice(2);
if (args.length < 2) {
  console.log('Usage: node render_svg.js <input.svg> <output.png> [--scale 2] [--width W] [--height H]');
  process.exit(1);
}
const inputSvg = args[0];
const outputPng = args[1];

function flagValue(name, fallback) {
  const idx = args.indexOf(name);
  return idx !== -1 && args[idx + 1] ? Number(args[idx + 1]) : fallback;
}
const scale = flagValue('--scale', 2);

if (!fs.existsSync(inputSvg)) {
  console.error(`Input SVG not found: ${inputSvg}`);
  process.exit(1);
}

// Read the SVG's viewBox to determine native dimensions, then scale up for
// crisper output (Word will display at whatever size you ask for in
// md_to_docx.js, but starting from a higher-res raster avoids blur).
const svgContent = fs.readFileSync(inputSvg, 'utf8');
const viewBoxMatch = svgContent.match(/viewBox="0 0 (\d+(?:\.\d+)?) (\d+(?:\.\d+)?)"/);
let width = flagValue('--width', null);
let height = flagValue('--height', null);
if (!width || !height) {
  if (viewBoxMatch) {
    width = Math.round(parseFloat(viewBoxMatch[1]));
    height = Math.round(parseFloat(viewBoxMatch[2]));
  } else {
    console.error('Could not determine SVG dimensions: no viewBox found and no --width/--height given.');
    process.exit(1);
  }
}

fs.mkdirSync(path.dirname(outputPng), { recursive: true });

sharp(inputSvg, { density: 220 })
  .resize(width * scale, height * scale)
  .png()
  .toFile(outputPng)
  .then(() => console.log(`Rendered ${outputPng} (${width * scale}x${height * scale})`))
  .catch(err => { console.error('Render failed:', err); process.exit(1); });
