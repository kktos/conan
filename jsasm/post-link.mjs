
const hexa = (v, len = 4) => {
	return `$${v.toString(16).padStart(len, "0").toUpperCase()}`;
};

function displaySegmentsTracksSectors(segmentDir) {
	for (const [name, offset, len, padLen, org, size] of segmentDir) {
		console.log(
		`T${hexa((offset>>12) & 0xFF,2)} S${hexa((offset>>8) & 0x0F,2)}`,
		hexa(offset, 8),
		name,
		);
	}
}

function pushNumber(list, value, endianSize) {
	const dataSize = Math.abs(endianSize);
	let numberValue = value;

	numberValue &= dataSize === 4 ? 0xffffffff : 0xffff;
	const byte3 = (numberValue >> 24) & 0xff;
	const byte2 = (numberValue >> 16) & 0xff;
	const byte1 = (numberValue >> 8) & 0xff;
	const byte0 = numberValue & 0xff;

	switch (endianSize) {
		// byte
		case 1:
			if (value > 0xff) throw "Data Overflow - 8bits expected";
			list.push(byte0);
			break;

		// word (2 bytes) little endian
		case 2:
			if (value > 0xffff) throw "Data Overflow - 16bits expected";
			list.push(byte0, byte1);
			break;

		// long (4 bytes) little endian
		case 4:
			list.push(byte0, byte1, byte2, byte3);
			break;

		// long (4 bytes) big endian
		case -4:
			list.push(byte3, byte2, byte1, byte0);
			break;

		// word (2 bytes) big endian
		case -2:
			list.push(byte1, byte0);
			break;
	}
}

function makeString(str) {
	const strAsArray= [];
	for(const c of Array.from(str)) {
		strAsArray.push( c.charCodeAt(0) );
	}
	return strAsArray;
}


function appendCatalogToBinary(bin, segmentDir) {
	const lenBeforeDir = bin.length;
	for (const [name, offset, len, padLen, org] of segmentDir) {
		const recordBuffer = makeString(name);
		recordBuffer.unshift(name.length);
		pushNumber(recordBuffer, offset, -4);
		pushNumber(recordBuffer, len + padLen, -4);
		pushNumber(recordBuffer, org, -4);

		const recordSize = [];
		pushNumber(recordSize, recordBuffer.length + 1, 1);

		bin.push(...recordSize, ...recordBuffer);
	}
	const dirOffset = [];
	pushNumber(dirOffset, lenBeforeDir, -4);
	bin.push(...dirOffset, ...makeString("DISK"));

}

export default function main(bin, segmentDir) {

	console.log("");
	console.log("Tracks/Sectors by Segments");
	displaySegmentsTracksSectors(segmentDir);

	console.log("");
	console.log("Appending Segments Catalog to the binary");

	appendCatalogToBinary(bin, segmentDir);

	return { bin };
}
