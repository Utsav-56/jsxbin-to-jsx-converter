import { format, version as prettierVersion } from "prettier";
import { readFileSync, writeFileSync } from "node:fs";

const args = Bun.argv.slice(2);

// 1. Handle --version flag
if (args.includes("--version")) {
    console.log(`
=========== Built with love by Utsav-56 ===========
visit github/utsav-56 to see his amazing works, 

Engine: 
Prettier : ${prettierVersion} 

=============================================
  `);
    process.exit(0);
}

const files = args.filter(arg => !arg.startsWith("-"));

if (files.length === 0) {
    console.error("Usage: Jsbeautify <file1> <file2> <file3> ...");
    process.exit(1);
}

/**
 * We define a helper function for a single file, 
 * then run them all in parallel at the bottom.
 */
async function processFile(filename: string) {
    try {
        const originalCode = readFileSync(filename, "utf-8");

        const formattedCode = await format(originalCode, {
            filepath: filename,
            semi: true,
            singleQuote: true,
            trailingComma: "all",
        });

        writeFileSync(filename, formattedCode);
        console.log(`Successfully Formatted: ${filename}`);
    } catch (err: any) {
        console.error(`Error formatting ${filename}: ${err.message}`);
    }
}

// Wrap in an async function for environment compatibility
async function main() {
    await Promise.all(files.map(processFile));
}

main().catch(err => {
    console.error(err);
    process.exit(1);
});