/**
 * c:\devwork\conan\tools\hgr_font_extract.js
 *
 * Extracts characters from an Apple II HGR image and outputs assembly-style hex data.
 *
 * Usage: node hgr_font_extract.js --file=<hgr_file> --width=<char_width> --height=<char_height> --perline=<chars_per_line> --chars=<expected_chars> [--x=<x_offset>] [--y=<y_offset>]
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

if (!args.file || !args.width || !args.height || !args.chars) {
    process.stdout.write("Usage: node hgr_font_extract.js --file=<hgr_file> --width=<char_width> --height=<char_height> --perline=<chars_per_line> --chars=<expected_chars> [--x=<x_offset>] [--y=<y_offset>] [--gap=<gap_x>]\n");
    process.exit(1);
}

function expandCharRanges(str) {
    let result = "";
    for (let i = 0; i < str.length; i++) {
        if (i + 2 < str.length && str[i+1] === '-') {
            const start = str.charCodeAt(i);
            const end = str.charCodeAt(i+2);
            if (start <= end) {
                for (let c = start; c <= end; c++) {
                    result += String.fromCharCode(c);
                }
                i += 2;
                continue;
            }
        }
        result += str[i];
    }
    return result;
}

const filename = args.file;
const charWidth = parseInt(args.width);
const charHeight = parseInt(args.height);
const expectedChars = expandCharRanges(args.chars);
const charsPerLine = parseInt(args.perline|| expectedChars.length);
const offsetX = parseInt(args.x || 0);
const offsetY = parseInt(args.y || 0);
const gapX = parseInt(args.gap || 0);

let inFile = fs.readFileSync(filename);

// --- HGR Constants & Setup ---
const kNumLines = 192;
const kPixelsPerLine = 280;

let fLineOffset = new Int16Array(kNumLines);

// Precompute HGR line offsets (interleaved memory layout)
for (let line = 0; line < kNumLines; line++) {
	let offset = (line & 0x07) << 10 | (line & 0x38) << 4 |
				(line & 0xc0) >> 1 | (line & 0xc0) >> 3;
	fLineOffset[line] = offset;
}

function getPixelHGR(x, y) {
    if (x < 0 || x >= kPixelsPerLine || y < 0 || y >= kNumLines) {
        return 0;
    }

    // Calculate byte offset and bit index
    // HGR stores 7 pixels per byte (bits 0-6). Bit 7 is palette.
    const byteOffset = fLineOffset[y] + Math.floor(x / 7);
    const bitIndex = x % 7;

    if (byteOffset >= inFile.length) return 0;

    const byte = inFile[byteOffset];
    // Extract the bit (LSB is left-most pixel in the group of 7 on screen, usually)
    return (byte >> bitIndex) & 1;
}

// --- Extraction ---
const prefix = "letter_";
let output= "";
output+= `prefix =\t\t"${prefix}"\n`;
output+= `width =\t\t\t${charWidth}\n`;
output+= `height =\t\t${charHeight}\n`;
output+= `gapX =\t\t\t${gapX}\n`;

for (let i = 0; i < expectedChars.length; i++) {
    const char = expectedChars[i];

    // Calculate grid position
    const gridX = i % charsPerLine;
    const gridY = Math.floor(i / charsPerLine);

    const startX = offsetX + (gridX * (charWidth + gapX));
    const startY = offsetY + (gridY * charHeight);

    let hexBytes = [];
    const bytesPerRow = Math.ceil(charWidth / 8);

    for (let y = 0; y < charHeight; y++) {
        for (let b = 0; b < bytesPerRow; b++) {
            let byteVal = 0;
            for (let bit = 0; bit < 8; bit++) {
                const px = b * 8 + bit;
                if (px < charWidth) {
                    const pixelOn = getPixelHGR(startX + px, startY + y);
                    if (pixelOn) {
                        // Pack into output byte (LSB first for Apple II)
                        byteVal |= (1 << bit);
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

    output+= `${prefix}${label}:`;
    let bytes= "";
    while (hexBytes.length) bytes+= "\t\t.hex "+hexBytes.splice(0,16).join(" ") + "\n";
    const isMultilines = hexBytes.length > 16;
    output+= isMultilines ? "\n":"";
    output+= bytes;
}

console.log(output);
