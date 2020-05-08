var fs = require('fs');
// var hexy = require('./hexy');
// var util = require('util');
var path = require('path');

if(process.argv.length < 3) {
	process.stdout.write("HGR filename missing !\n");
	process.exit(1);
}
let filename= process.argv[2];

let inFile = fs.readFileSync(filename);

const kNumLines = 192;
const kPixelsPerLine = 280;
const kLeadIn = 4;
const kOutputWidth = kPixelsPerLine * 2;
const kOutputHeight = kNumLines * 2;

/* color map */
const kColorBlack0 = 0;
const kColorGreen=1;
const kColorPurple=2;
const kColorWhite0=3;
const kColorBlack1=4;
const kColorOrange=5;
const kColorBlue=6;
const kColorWhite1=7;
const kColorNone=8;     // really only useful for debugging
const kNumColors=9;
	
let outBuf= new Uint8Array(kPixelsPerLine * kNumLines * 4 / 2);
let colorBuf= new Uint16Array(kLeadIn + kOutputWidth + 1);
let fLineOffset= new Int16Array(kNumLines);
let pixelBits= new Int16Array(kPixelsPerLine);
let shiftBits= new Int16Array(kPixelsPerLine);

for (let line = 0; line < kNumLines; line++) {
	let offset = (line & 0x07) << 10 | (line & 0x38) << 4 |
				(line & 0xc0) >> 1 | (line & 0xc0) >> 3;
	fLineOffset[line] = offset;
}


for (let line = 0; line < kNumLines; line++) {

	const lineBuf= inFile.slice(fLineOffset[line], fLineOffset[line] + kPixelsPerLine / 7);

	/* unravel the bits */
	for (let byt = 0; byt < kPixelsPerLine / 7; byt++) {
		let val = lineBuf[byt];
		const shifted = (val & 0x80) != 0;

		for (let bit = 0; bit < 7; bit++) {
			pixelBits[byt*7+bit]= val & 0x01;
			shiftBits[byt*7+bit]= shifted;
			val >>= 1;
		}

		for (let idx = 0; idx < colorBuf.length; idx++) {
			colorBuf[idx] = kColorNone;		
		}

		for (let idx = 0; idx < kPixelsPerLine; idx ++) {
			let bufShift = shiftBits[idx];
			let colorShift = 4 * bufShift;
			let bufTarget = kLeadIn + idx * 2 + bufShift;

			if(!pixelBits[idx]) {
				colorBuf[bufTarget] = kColorBlack0 + colorShift;
				colorBuf[bufTarget+1] = kColorBlack0 + colorShift;
			} else {
				if (colorBuf[bufTarget-2] != kColorBlack0 &&
					colorBuf[bufTarget-2] != kColorBlack1 &&
					colorBuf[bufTarget-2] != kColorNone)
				{
					/* previous bit was set, this is white */
					colorBuf[bufTarget] = kColorWhite0 + colorShift;
					colorBuf[bufTarget+1] = kColorWhite0 + colorShift;

					/* make sure the previous bit is in with us */
					colorBuf[bufTarget-2] = kColorWhite0 + colorShift;
					colorBuf[bufTarget-1] = kColorWhite0 + colorShift;
				} else {
					/* previous bit was zero, this is color */
					if (idx & 0x01) {
						colorBuf[bufTarget] = kColorGreen + colorShift;
						colorBuf[bufTarget+1] = kColorGreen + colorShift;
					} else {
						colorBuf[bufTarget] = kColorPurple + colorShift;
						colorBuf[bufTarget+1] = kColorPurple + colorShift;
					}

					/*
					 * Do we have a run of the same color?  If so, smooth
					 * the color out.  Note that white blends smoothly
					 * with everything.
					 */
					if (colorBuf[bufTarget-4] == colorBuf[bufTarget] ||
						colorBuf[bufTarget-4] == kColorWhite0 ||
						colorBuf[bufTarget-4] == kColorWhite1)
					{
						/* back-fill previous gap with color */
						colorBuf[bufTarget-2] = colorBuf[bufTarget];
						colorBuf[bufTarget-1] = colorBuf[bufTarget];
					}
				}
			}
		}

        for (let pix = 0; pix < kPixelsPerLine; pix++) {
            let bufPosn = kLeadIn + pix * 2;

			pix4 = colorBuf[bufPosn] << 4 | colorBuf[bufPosn+1];
			
			outBuf[((kOutputHeight-1) - (line*2)) * (kOutputWidth/2) + (pix)] = pix4;
			outBuf[((kOutputHeight-1) - (line*2+1)) * (kOutputWidth/2) + (pix)] = pix4;

		}
		
	}

}

const filesize = 14 + 40 + 36 + outBuf.length;
let tempBuf;

const fileext= path.extname(filename);
filename= filename.replace(new RegExp(fileext+"$"), ".bmp");
let outFile= fs.createWriteStream(filename,"binary");

// BMP File Header
tempBuf= Buffer.alloc(14);
tempBuf.write("BM");
tempBuf.writeInt32LE(filesize, 2);
tempBuf.writeInt8(14 + 40 + 36,10);
outFile.write( tempBuf );

// BMP Info Header
tempBuf= Buffer.alloc(40);
tempBuf.writeInt8(40,0);
tempBuf.writeInt32LE(kOutputWidth, 4);
tempBuf.writeInt32LE(kOutputHeight, 8);
tempBuf.writeInt8(1,12);
tempBuf.writeInt8(4,14);
tempBuf.writeInt8(9,32);
outFile.write( tempBuf );

// BMP Colour table
tempBuf= Buffer.from("0000000000DD1100DD22DD00FFFFFF00000000000066FF00FF222200FFFFFF0000000000", "hex");
outFile.write( tempBuf );

outFile.write( Buffer.from(outBuf) );

outFile.end();