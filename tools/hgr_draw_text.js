/**
 * c:\devwork\conan\tools\hgr_draw_text.js
 *
 * Draws text onto an HGR image using a font extracted by hgr_font_extract.js or bmp_font_extract.js.
 * Reads the hex output format (.asm) and renders it to the HGR binary.
 *
 * Usage: node hgr_draw_text.js --font=<font.asm> --hgr=<target.hgr> --text="HELLO WORLD" --x=10 --y=10
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
        } else {
            const key = val.substring(2);
            args[key] = true;
        }
    }
});

if (!args.font || !args.hgr || !args.text) {
    process.stdout.write("Usage: node hgr_draw_text.js --font=<font.asm> --hgr=<target.hgr> --text=<text> --x=<x> --y=<y> [--new]\n");
    process.exit(1);
}

const fontFile = args.font;
const hgrFile = args.hgr;
const text = args.text;
const startX = parseInt(args.x || 0);
const startY = parseInt(args.y || 0);
const spacing = parseInt(args.spacing || 0);
const createNew = args.new;

// --- HGR Setup ---

const kNumLines = 192;
const kPixelsPerLine = 280;
const kHGRSize = 8192;

let hgrBuffer;
if (!createNew && fs.existsSync(hgrFile)) {
    hgrBuffer = fs.readFileSync(hgrFile);
    if (hgrBuffer.length < kHGRSize) {
        // Expand if too small (unlikely for valid HGR, but safe)
        const newBuf = Buffer.alloc(kHGRSize);
        hgrBuffer.copy(newBuf);
        hgrBuffer = newBuf;
    }
} else {
    hgrBuffer = Buffer.alloc(kHGRSize);
}

// Precompute HGR line offsets
let fLineOffset = new Int16Array(kNumLines);
for (let line = 0; line < kNumLines; line++) {
	let offset = (line & 0x07) << 10 | (line & 0x38) << 4 |
				(line & 0xc0) >> 1 | (line & 0xc0) >> 3;
	fLineOffset[line] = offset;
}

function setPixel(x, y) {
    if (x < 0 || x >= kPixelsPerLine || y < 0 || y >= kNumLines) return;

    const offset = fLineOffset[y] + Math.floor(x / 7);
    const bit = x % 7;

    // Set the pixel bit (OR operation to overlay)
    hgrBuffer[offset] |= (1 << bit);
}

// --- Font Parsing ---

const fontData = fs.readFileSync(fontFile, 'utf8');
const fontMap = {};
const lines = fontData.split(/\r?\n/);
let currentLabel = null;
let currentHex = [];
let charWidth = 0;
let charHeight = 0;
let gapX = 0;
let gapY = 0;
let letterPrefix= "";

const parseHex= (hexline) => {
	const hexbytes= hexline.replace(".hex ", "");
	currentHex.push(hexbytes)

	// Parse accumulated hex strings
	let bytes = [];
	currentHex.forEach(hStr => {
		hStr.split(/\s+/).forEach(b => {
			if (b) bytes.push(parseInt(b, 16));
		});
	});
	fontMap[currentLabel].push(...bytes);
};

for (let line of lines) {
    line = line.trim();
    if (!line) continue;

    const [param, value] = line.split(/\s*=\s*/);
    switch (param) {
	case "width":
	    charWidth = parseInt(value);
	    break;
	case "height":
	    charHeight = parseInt(value);
	    break;
	case "gapX":
	    gapX = parseInt(value);
	    break;
	case "gapY":
	    gapY = parseInt(value);
	    break;
	case "prefix":
	    letterPrefix = value.replace(/"/g, "");
	    break;
    }
	if(value !== undefined) continue;

	const parts = line.split(/\s*:\s*/);
	let hexline;
	if (parts.length === 2) {
		currentLabel = parts[0].replace(letterPrefix, "");

		if (currentLabel.startsWith("Char_")) {
			const hex = currentLabel.substring(5);
			const code = parseInt(hex, 16);
			if (!Number.isNaN(code)) currentLabel= String.fromCharCode(code);
		}

		fontMap[currentLabel] = [];

		currentHex = [];
		hexline= parts[1];
	} else hexline= parts[0];

	parseHex(hexline);
}

// --- Drawing ---

let cursorX = startX;
let cursorY = startY;
const bytesPerRow = Math.ceil(charWidth / 8);

for (let i = 0; i < text.length; i++) {
    const char = text[i];

    if (char === '\n') {
        cursorX = startX;
        cursorY += charHeight + gapY;
        continue;
    }

    // Determine lookup key (matches logic in extraction scripts)
    let bytes = fontMap[char];
    let key = char;

    if (!bytes && !/^[a-zA-Z]$/.test(char)) {
        key = "Char_" + char.charCodeAt(0).toString(16).toUpperCase();
        bytes = fontMap[key];
    }

    if (bytes) {
        // Draw Character
        for (let y = 0; y < charHeight; y++) {
            for (let b = 0; b < bytesPerRow; b++) {
                const byteIndex = y * bytesPerRow + b;
                if (byteIndex >= bytes.length) break;

                const val = bytes[byteIndex];

                for (let bit = 0; bit < 8; bit++) {
                    const px = b * 8 + bit;
                    if (px >= charWidth) break;

                    // Font format: LSB is left-most pixel
                    const isSet = (val >> bit) & 1;

                    if (isSet) {
                        setPixel(cursorX + px, cursorY + y);
                    }
                }
            }
        }
    } else if (char !== ' ') {
        process.stdout.write(`Warning: Character '${char}' (Key: ${key}) not found in font.\n`);
    }

    // Advance cursor
    cursorX += charWidth + gapX + spacing;
}

// --- Output ---

fs.writeFileSync(hgrFile, hgrBuffer);
process.stdout.write(`Wrote to ${hgrFile}\n`);
