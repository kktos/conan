var fs = require('fs');
var hexy = require('./hexy');
var path = require('path');

const kNumLines = 192;
const kPixelsPerLine = 280;

if(process.argv.length < 3) {
	process.stdout.write("HGRPacked filename missing !\n");
	process.exit(1);
}
let filename= process.argv[2];

let inFile = fs.readFileSync(filename);

let fLineOffset= new Int16Array(kNumLines);
for (let line = 0; line < kNumLines; line++) {
	let offset = (line & 0x07) << 10 | (line & 0x38) << 4 |
				(line & 0xc0) >> 1 | (line & 0xc0) >> 3;
	fLineOffset[line] = offset;
}

let outBuf= new Uint8Array(0x2000);
let yPos= 0;
let xPos= 0;
let isUnpacked= false;

function storePix(val) {
	if(isUnpacked) {
		return;
	}

	outBuf[ fLineOffset[yPos] + xPos ]= val;

	yPos++;
	if(yPos==0xB7) {
		yPos= 0;
		xPos++;
		if(xPos==0x28) {
			isUnpacked= true;
		}
	}
}

let index = 0;
while (index < inFile.length) {
	const element = inFile[index];

	if(element == 0xFE) {

		const value= inFile[index+1];
		const count= inFile[index+2];

		for(let idx= 0; idx < count; idx++) {
			storePix(value);
		}

		index+= 2;

	}
	else {
		storePix(element);
	}

	index++;

}
const fileext= path.extname(filename);
filename= filename.replace(new RegExp(fileext+"$"), ".hgr");
let outFile= fs.createWriteStream(filename,"binary");

outFile.write( Buffer.from(outBuf) );

outFile.end();

process.stdout.write(`unpacked: ${filename}\n`);