#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { Jimp } from 'jimp';
import { rgbaToInt } from "@jimp/utils";

// Regex to parse the hex data files. It finds hex values, ignoring other text.
const HEX_CONTENT_RE = /([0-9a-fA-F]{2})/g;

// Regex to parse the sprite definition file.
// Captures: 1=width, 2=height, 3=address, 4=optional index
const SPRITE_DEF_RE = /defprite\s+\$([0-9a-fA-F]+),\s*\$([0-9a-fA-F]+),\s*\$([0-9a-fA-F]+)(?:\s*;\s*(\d+))?/;

// Regex to determine the memory range from a data file's name.
// e.g., M4000-4FFF -> 4000
const DATA_FILE_START_ADDR_RE = /M([0-9a-fA-F]{4})/i;

/**
 * Reads a ca65 hex file and returns its content as a Buffer.
 * @param {string} filePath
 * @returns {Buffer}
 */
function parseHexDataFile(filePath) {
    const content = fs.readFileSync(filePath, 'utf-8');
    const hexValues = content.match(HEX_CONTENT_RE) || [];
    return Buffer.from(hexValues.join(''), 'hex');
}

/**
 * Loads multiple hex data files into a memory map (object).
 * @param {string[]} dataFiles
 * @returns {Object.<number, number>}
 */
function loadMemoryMap(dataFiles) {
    const memory = {};
    for (const filePath of dataFiles) {
        const fileName = path.basename(filePath);
        const match = fileName.match(DATA_FILE_START_ADDR_RE);
        if (!match) {
            console.warn(`Warning: Could not determine start address for ${fileName}. Skipping.`);
            continue;
        }
        const startAddr = parseInt(match[1], 16);
        const data = parseHexDataFile(filePath);
        for (let i = 0; i < data.length; i++) {
            memory[startAddr + i] = data[i];
        }
    }
    return memory;
}

/**
 * Parses the sprite definition file and returns a list of sprite info objects.
 * @param {string} defFile
 * @returns {Array<Object>}
 */
function parseSpriteDefinitions(defFile) {
    const definitions = [];
    const lines = fs.readFileSync(defFile, 'utf-8').split(/\r?\n/);

    let currentGroupName = "";
    let spriteCounter = 0;

    for (const line of lines) {
        const trimmedLine = line.trim();

        // Skip lines that are not definitions or group comments
        if (!trimmedLine || trimmedLine.startsWith('.') || trimmedLine.startsWith('sprites:')) {
            continue;
        }

        // Check for a group comment to determine the name prefix
        if (trimmedLine.startsWith(';')) {
            const commentText = trimmedLine.substring(1).trim();
            // Try to match "10-15 Conan Walk/Stand"
            const nameMatch = commentText.match(/^\d+-\d+\s+(.*)/);
            if (nameMatch) {
                // Sanitize name: "Conan Walk/Stand" -> "conan_walk_stand"
                const name = nameMatch[1].trim().toLowerCase().replace(/\//g, '_').replace(/ /g, '_');
                currentGroupName = name.replace(/[^a-zA-Z0-9_]/g, '');
            } else if (commentText.includes("digits")) {
                currentGroupName = "digit";
            }
            continue;
        }

        const spriteMatch = trimmedLine.match(SPRITE_DEF_RE);
        if (spriteMatch) {
            const width = parseInt(spriteMatch[1], 16);
            const height = parseInt(spriteMatch[2], 16);
            const address = parseInt(spriteMatch[3], 16);

            // Use index from comment if present, otherwise use counter
            let spriteIndex;
            if (spriteMatch[4]) {
                spriteIndex = parseInt(spriteMatch[4], 10);
                spriteCounter = spriteIndex; // Sync counter
            } else {
                spriteIndex = spriteCounter;
            }

            const effectiveHeight = height & 0x7F;
            const numFrames = 7;
            const size = width * effectiveHeight * numFrames;

            // Determine the label name
            const prefix = currentGroupName || "sprite";
            const labelName = `${prefix}_${spriteIndex}`;

            definitions.push({
                index: spriteIndex,
                width: width,
                height: height,
                address: address,
                size: size,
                name: labelName
            });

            spriteCounter++;
        }
    }
    return definitions;
}

/**
 * Formats byte data into the ca65 .hex format.
 * @param {string} label
 * @param {Buffer} data
 * @param {number} address
 * @returns {string}
 */
function formatHexOutput(label, data, address) {
    const addressComment = `; $${address.toString(16).toUpperCase()}`;
    const output = [addressComment, `${label}:`];
    const chunkSize = 16;
    for (let i = 0; i < data.length; i += chunkSize) {
        const chunk = data.slice(i, i + chunkSize);
        const hexString = Array.from(chunk)
            .map(byte => byte.toString(16).toUpperCase().padStart(2, '0'))
            .join(' ');
        output.push(`\t\t.hex ${hexString}`);
    }
    return output.join('\n');
}

/**
 * Generates a PNG preview for a single sprite (all 7 frames).
 * @param {Object} sprite The sprite definition object.
 * @param {Buffer} spriteData The raw byte data for the sprite.
 * @param {string} previewDir The directory to save the PNG file.
 */
async function generateSpritePreview(sprite, spriteData, previewDir) {
    try {
        const width = sprite.width;
        const height = sprite.height & 0x7F;
        const numFrames = 7;
        const frameSize = width * height;
        const spacing = 2; // Pixels between frames
        const imageWidth = (width * numFrames) + (spacing * (numFrames - 1));
        const imageHeight = height;

        if (imageWidth <= 0 || imageHeight <= 0) {
            console.warn(`- Skipping preview for sprite ${sprite.index} (label: ${sprite.name}) due to zero dimensions.`);
            return;
        }

        // Create a new image with a light gray background
        const image = new Jimp({width: imageWidth, height:imageHeight, color:0xE0E0E0FF});

	try {
		for (let f = 0; f < numFrames; f++) {
		    const frameOffset = f * frameSize;
		    for (let y = 0; y < height; y++) {
			for (let x = 0; x < width; x++) {
			    const pixelIndex = frameOffset + (y * width) + x;
			    if (pixelIndex >= spriteData.length) continue;

			    const pixelValue = spriteData[pixelIndex];
			    if (pixelValue === 0) continue; // Treat 0 as transparent (shows background)

			    // Using grayscale for visualization. A real implementation would use a color palette.
			    const color = rgbaToInt(pixelValue, pixelValue, pixelValue, 255);
			    const drawX = f * (width + spacing) + x;
			    image.setPixelColor(color, drawX, y);
			}
		    }
		}
	}
	catch(e) {
		console.error(`\nLOOP: ${e}`);
		throw e;
	}

        // Render each frame

	try  {
		const outputPath = path.join(previewDir, `${sprite.name}.png`);
		await image.write(outputPath);
	}
	catch(e) {
		console.error(`\nWRITE: ${e}`);
		throw e;
	}

    } catch (err) {
        console.error(`\nERROR generating preview for sprite ${sprite.index}: ${err.message}`);
    }
}

/**
 * Main function to run the sprite extraction process.
 */
async function main() {
    // Manual argument parsing
    const rawArgs = process.argv.slice(2);
    const args = { def_file: null, data_files: [], output: null, sprite: null, preview: null };

    for (let i = 0; i < rawArgs.length; ) {
        const arg = rawArgs[i];
        if (arg === '-o' || arg === '--output') {
            args.output = rawArgs[i + 1];
            i += 2;
        } else if (arg === '--preview') {
            args.preview = rawArgs[i + 1];
            i += 2;
        } else if (arg === '-s' || arg === '--sprite') {
            const spriteArgs = [];
            i++;
            while (i < rawArgs.length && !rawArgs[i].startsWith('-')) {
                spriteArgs.push(parseInt(rawArgs[i], 10));
                i++;
            }
            args.sprite = spriteArgs;
        } else {
            if (!args.def_file) args.def_file = arg;
            else args.data_files.push(arg);
            i++;
        }
    }

    if (!args.def_file || args.data_files.length === 0) {
        console.error("Usage: node sprite_extractor.js <def_file> <data_file1> ... [--output <file>] [--sprite <index> ...] [--preview <dir>]");
        return;
    }

    // Create preview directory if it doesn't exist
    if (args.preview) {
        if (!fs.existsSync(args.preview)) {
            fs.mkdirSync(args.preview, { recursive: true });
        }
    }

    console.log("Loading memory from data files...");
    const memoryMap = loadMemoryMap(args.data_files);
    console.log(`Loaded ${Object.keys(memoryMap).length} bytes into memory.`);

    console.log(`Parsing sprite definitions from ${args.def_file}...`);
    const spriteDefs = parseSpriteDefinitions(args.def_file);
    console.log(`Found ${spriteDefs.length} sprite definitions.`);

    const outputParts = [];
    let spritesToProcess = spriteDefs;
    if (args.sprite && args.sprite.length > 0) {
        spritesToProcess = spriteDefs.filter(s => args.sprite.includes(s.index));
        if (spritesToProcess.length === 0) {
            console.warn(`Warning: No definitions found for specified sprite indices: ${args.sprite.join(', ')}`);
            return;
        }
    }

    for (const sprite of spritesToProcess) {
        const { address, size, index, name: label } = sprite;
        const spriteData = Buffer.alloc(size);
        let dataMissing = false;
        for (let i = 0; i < size; i++) {
            const currentAddr = address + i;
            if (memoryMap[currentAddr] === undefined) {
                console.error(`Error: Missing data for sprite ${index} at address 0x${currentAddr.toString(16)}. Aborting sprite.`);
                dataMissing = true;
                break;
            }
            spriteData[i] = memoryMap[currentAddr];
        }

        if (!dataMissing) {
            const formattedSprite = formatHexOutput(label, spriteData, address);
            outputParts.push(formattedSprite);
            let logMessage = `Extracted sprite ${index} (Label: ${label}, Address: 0x${address.toString(16)}, Size: ${size} bytes).`;
            if (args.preview) {
                await generateSpritePreview(sprite, spriteData, args.preview);
                logMessage += ` -> Preview: ${path.join(args.preview, `${label}.png`)}`;
            }
            console.log(logMessage);
        }
    }

    const finalOutput = outputParts.join('\n\n');
    if (args.output) {
        await fs.promises.writeFile(args.output, finalOutput, 'utf-8');
        console.log(`\nSuccessfully wrote extracted sprite data to ${args.output}`);
    } else {
        console.log("\n--- EXTRACTED SPRITE DATA ---\n");
        console.log(finalOutput);
    }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
    main().catch(err => console.error(err));
}
