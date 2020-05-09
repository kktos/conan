const { exec } = require("child_process");


function call(script, parms) {
	return new Promise((resolve, reject) => {

		exec("node "+script+" "+parms, (error, stdout, stderr) => {
			if(error) {
				console.log(`error: ${error.message}`);
				reject(error.message)
				return;
			}
			if(stderr) {
				console.log(`stderr: ${stderr}`);
				reject(stderr)
				return;
			}
			process.stdout.write(stdout);
			resolve(stdout);
		});

	});
	
}

async function unpackImg(filename) {
	return call("./hgr_unpack.js", filename+".pakhgr");
}

async function convertToBmp(filename) {
	return call("./hgr_tobmp.js", filename+".hgr");
}

(async function main() {
	for (let index = 0; index < 9; index++) {
		const filename= "../assets/imgs/level"+index;
		await unpackImg(filename);
		convertToBmp(filename);
	}
})();
