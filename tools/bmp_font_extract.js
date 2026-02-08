/**
 * c:\devwork\conan\tools\bmp_font_extract.js
 *
 * Extracts characters from a BMP font image and outputs assembly-style hex data.
 *
 * Usage: node bmp_font_extract.js <bmp_file> <char_width> <char_height> <chars_per_line> <expected_chars>
 * Example: node bmp_font_extract.js font.bmp 8 8 16 "ABCDEFGHIJKLMNOP"
 */

var fs = require('fs');

const args = {};
process.argv.slice(2).forEach(val => {
    if (val.startsWith('--')) {
        const eqIndex = val.indexOf('=');
        if (eqIndex !== -1) {
            const key = val.substring(2, eqIndex);
            const value = val.substring(eqIndex + 1);
            args[key] = value;
        }
    }
});

if (!args.file || !args.width || !args.height || !args.perline || !args.chars) {
    process.stdout.write("Usage: node bmp_font_extract.js --file=<bmp_file> --width=<char_width> --height=<char_height> --perline=<chars_per_line> --chars=<expected_chars> [--x=<x_offset>] [--y=<y_offset>]\n");
    process.exit(1);
}

const filename = args.file;
const charWidth = parseInt(args.width);
const charHeight = parseInt(args.height);
const charsPerLine = parseInt(args.perline);
const expectedChars = args.chars;
const offsetX = parseInt(args.x || 0);
const offsetY = parseInt(args.y || 0);

let inFile = fs.readFileSync(filename);

// --- BMP Parsing ---

if (inFile.toString('ascii', 0, 2) !== 'BM') {
    process.stdout.write("Not a valid BMP file.\n");
    process.exit(1);
}

const dataOffset = inFile.readUInt32LE(10);
const width = inFile.readInt32LE(18);
const height = inFile.readInt32LE(22);
const bpp = inFile.readUInt16LE(28);

const rowSize = Math.floor((bpp * width + 31) / 32) * 4;

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
        const paletteStart = 54;
        const byteIndex = offset + Math.floor(x / 2);
        const byte = inFile[byteIndex];
        let index;
        if (x % 2 === 0) {
            index = (byte >> 4) & 0x0F;
        } else {
            index = byte & 0x0F;
        }
        const palEntry = paletteStart + index * 4;
        return { r: inFile[palEntry+2], g: inFile[palEntry+1], b: inFile[palEntry] };
    } else if (bpp === 8) {
        const paletteStart = 54;
        const index = inFile[offset + x];
        const palEntry = paletteStart + index * 4;
        return { r: inFile[palEntry+2], g: inFile[palEntry+1], b: inFile[palEntry] };
    }

    return {r:0, g:0, b:0};
}

// --- Extraction ---

for (let i = 0; i < expectedChars.length; i++) {
    const char = expectedChars[i];

    // Calculate grid position
    const gridX = i % charsPerLine;
    const gridY = Math.floor(i / charsPerLine);

    const startX = offsetX + (gridX * charWidth);
    const startY = offsetY + (gridY * charHeight);

    let hexBytes = [];
    const bytesPerRow = Math.ceil(charWidth / 8);

    for (let y = 0; y < charHeight; y++) {
        for (let b = 0; b < bytesPerRow; b++) {
            let byteVal = 0;
            for (let bit = 0; bit < 8; bit++) {
                const px = b * 8 + bit;
                if (px < charWidth) {
                    const rgb = getPixelRGB(startX + px, startY + y);
                    // Assume non-black is ON (1)
                    if (rgb.r > 32 || rgb.g > 32 || rgb.b > 32) {
                        byteVal |= (1 << (7 - bit));
                    }
                }
            }
            let hex = byteVal.toString(16).toUpperCase();
            if (hex.length < 2) hex = "0" + hex;
            hexBytes.push(hex);
        }
    }

    // Generate Label: Use character if it's a valid letter, otherwise Char_HEX
    let label = /^[a-zA-Z]$/.test(char) ? char : "Char_" + char.charCodeAt(0).toString(16).toUpperCase();

    console.log(`${label}:`);
    console.log(".hex");
    console.log(hexBytes.join(" "));
    console.log(".end");
}
