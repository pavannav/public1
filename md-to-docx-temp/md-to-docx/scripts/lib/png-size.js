// Minimal PNG dimension reader — no dependencies.
// PNG spec: bytes 16-19 = width (big-endian uint32), bytes 20-23 = height.
const fs = require('fs');

module.exports = function pngSize(filePath) {
  const fd = fs.openSync(filePath, 'r');
  const buf = Buffer.alloc(24);
  fs.readSync(fd, buf, 0, 24, 0);
  fs.closeSync(fd);

  const isPng = buf[0] === 0x89 && buf[1] === 0x50 && buf[2] === 0x4e && buf[3] === 0x47;
  if (!isPng) {
    throw new Error(`Not a PNG file (or unreadable header): ${filePath}`);
  }
  const width = buf.readUInt32BE(16);
  const height = buf.readUInt32BE(20);
  return { width, height };
};
