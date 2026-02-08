/**
 * c:\devwork\conan\tools\bmp_tohgr.js
 *
 * Converts a BMP image back to Apple II HGR format.
 * Supports 24-bit, 32-bit, and 4-bit/8-bit palette BMPs.
 * Designed to handle the 560x384 artifacted output from hgr_tobmp.js
 * as well as 280x192 source images.
 */

var fs = require('fs');
var path = require('path');

if(process.argv.length < 3) {
	process.stdout.write("BMP filename missing !\n");
	process.exit(1);
}
let filename= process.argv[2];

let inFile = fs.readFileSync(filename);

// --- BMP Parsing ---

// Check signature
if (inFile.toString('ascii', 0, 2) !== 'BM') {
    process.stdout.write("Not a valid BMP file.\n");
    process.exit(1);
}

const dataOffset = inFile.readUInt32LE(10);
const width = inFile.readInt32LE(18);
const height = inFile.readInt32LE(22);
const bpp = inFile.readUInt16LE(28);

// Basic validation
if (width < 280 || Math.abs(height) < 192) {
    process.stdout.write("Image too small. Must be at least 280x192.\n");
    process.exit(1);
}

// Determine scaling factors (hgr_tobmp produces double width/height)
const scaleX = width / 280;
const scaleY = Math.abs(height) / 192;

// Calculate stride (row size aligned to 4 bytes)
const rowSize = Math.floor((bpp * width + 31) / 32) * 4;

// --- HGR Constants ---
const kNumLines = 192;
const kPixelsPerLine = 280;
const kBytesPerLine = 40;

let outBuf = new Uint8Array(8192);
let fLineOffset = new Int16Array(kNumLines);

// Precompute HGR line offsets (interleaved memory layout)
for (let line = 0; line < kNumLines; line++) {
	let offset = (line & 0x07) << 10 | (line & 0x38) << 4 |
				(line & 0xc0) >> 1 | (line & 0xc0) >> 3;
	fLineOffset[line] = offset;
}

// Color definitions (approximate RGB values matching hgr_tobmp palette)
const COLORS = {
    BLACK:  { r: 0,   g: 0,   b: 0 },
    GREEN:  { r: 17,  g: 221, b: 0 },   // 0x11DD00
    PURPLE: { r: 221, g: 34,  b: 221 }, // 0xDD22DD
    WHITE:  { r: 255, g: 255, b: 255 },
    ORANGE: { r: 255, g: 102, b: 0 },   // 0xFF6600
    BLUE:   { r: 34,  g: 34,  b: 255 }  // 0x2222FF
};

// Helper to read pixel RGB from BMP buffer
function getPixelRGB(x, y) {
    let row;
    // Handle bottom-up (positive height) vs top-down (negative height)
    if (height > 0) {
        row = (height - 1) - y;
    } else {
        row = y;
    }

    // Clamp coordinates
    x = Math.floor(x);
    row = Math.floor(row);
    if (x < 0) x = 0;
    if (x >= width) x = width - 1;
    if (row < 0) row = 0;
    if (row >= Math.abs(height)) row = Math.abs(height) - 1;

    const offset = dataOffset + (row * rowSize);

    if (bpp === 24) {
        const p = offset + x * 3;
        return { r: inFile[p+2], g: inFile[p+1], b: inFile[p] };
    } else if (bpp === 32) {
        const p = offset + x * 4;
        return { r: inFile[p+2], g: inFile[p+1], b: inFile[p] };
    } else if (bpp === 4) {
        // 4-bit Palette (used by hgr_tobmp.js)
        // Palette is usually after the 40-byte info header + 14-byte file header
        const paletteStart = 54;
        const byteIndex = offset + Math.floor(x / 2);
        const byte = inFile[byteIndex];
        let index;
        if (x % 2 === 0) {
            index = (byte >> 4) & 0x0F; // High nibble is even pixel
        } else {
            index = byte & 0x0F;        // Low nibble is odd pixel
        }
        const palEntry = paletteStart + index * 4;
        return { r: inFile[palEntry+2], g: inFile[palEntry+1], b: inFile[palEntry] };
    } else if (bpp === 8) {
        // 8-bit Palette
        const paletteStart = 54;
        const index = inFile[offset + x];
        const palEntry = paletteStart + index * 4;
        return { r: inFile[palEntry+2], g: inFile[palEntry+1], b: inFile[palEntry] };
    }

    return {r:0, g:0, b:0};
}

// Find closest HGR color
function matchColor(rgb) {
    let minD = Infinity;
    let match = 'BLACK';

    for (const key in COLORS) {
        const c = COLORS[key];
        const d = (rgb.r - c.r)**2 + (rgb.g - c.g)**2 + (rgb.b - c.b)**2;
        if (d < minD) {
            minD = d;
            match = key;
        }
    }
    return match;
}

// --- Main Conversion Loop ---

for (let y = 0; y < kNumLines; y++) {
    const bmpY = y * scaleY;

    for (let byte = 0; byte < kBytesPerLine; byte++) {
        let pixelColors = [];
        let group0Votes = 0; // Green/Purple (High Bit 0)
        let group1Votes = 0; // Orange/Blue  (High Bit 1)

        // 1. Analyze the 7 pixels corresponding to this byte
        for (let bit = 0; bit < 7; bit++) {
            const hgrX = byte * 7 + bit;
            const bmpX = hgrX * scaleX;

            const rgb = getPixelRGB(bmpX, bmpY);
            const colorName = matchColor(rgb);
            pixelColors.push(colorName);

            if (colorName === 'GREEN' || colorName === 'PURPLE') group0Votes++;
            if (colorName === 'ORANGE' || colorName === 'BLUE') group1Votes++;
        }

        // 2. Determine High Bit (Palette) for this byte based on majority vote
        let highBit = (group1Votes > group0Votes) ? 1 : 0;

        let outByte = (highBit << 7);

        // 3. Set pixel bits
        for (let bit = 0; bit < 7; bit++) {
            const colorName = pixelColors[bit];
            const hgrX = byte * 7 + bit;
            const isOdd = (hgrX % 2 !== 0);
            let bitSet = false;

            if (colorName === 'WHITE') {
                bitSet = true;
            } else if (colorName === 'BLACK') {
                bitSet = false;
            } else {
                // Color logic based on HGR artifacting rules
                if (highBit === 0) {
                    // Group 0: Green (Odd), Purple (Even)
                    if (colorName === 'GREEN' && isOdd) bitSet = true;
                    if (colorName === 'PURPLE' && !isOdd) bitSet = true;

                    // If we are forced into Group 0 but have Group 1 colors,
                    // we map them to the active bit to preserve luminance/pattern
                    if (colorName === 'ORANGE' && isOdd) bitSet = true;
                    if (colorName === 'BLUE' && !isOdd) bitSet = true;
                } else {
                    // Group 1: Orange (Odd), Blue (Even)
                    if (colorName === 'ORANGE' && isOdd) bitSet = true;
                    if (colorName === 'BLUE' && !isOdd) bitSet = true;

                    // Fallback mapping
                    if (colorName === 'GREEN' && isOdd) bitSet = true;
                    if (colorName === 'PURPLE' && !isOdd) bitSet = true;
                }
            }

            if (bitSet) {
                outByte |= (1 << bit);
            }
        }

        outBuf[fLineOffset[y] + byte] = outByte;
    }
}

// --- Output ---

const fileext = path.extname(filename);
let outFilename = filename.replace(new RegExp(fileext + "$", "i"), ".hgr");
if (outFilename === filename) outFilename += ".hgr";

fs.writeFileSync(outFilename, outBuf);
process.stdout.write(`converted: ${outFilename}\n`);
