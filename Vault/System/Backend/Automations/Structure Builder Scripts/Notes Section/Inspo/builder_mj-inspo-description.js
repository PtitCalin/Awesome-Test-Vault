#!/usr/bin/env node

// -----------------------------------------------------------------------------------
// 🎨 MidJourney Inspo Batch Folder Builder (Node.js Version)
// -----------------------------------------------------------------------------------
// USAGE:
//   node builder_mj-inspo-description.js --batch 3 --start 42 [--dry-run]
// -----------------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');

// === Parse Arguments ===
const args = process.argv.slice(2);
let batch = 1;
let start = 1;
let dryRun = false;

args.forEach((arg, index) => {
    if (arg === '--batch') batch = parseInt(args[index + 1]);
    if (arg === '--start') start = parseInt(args[index + 1]);
    if (arg === '--dry-run') dryRun = true;
});

if (!batch || !start) {
    console.error('❌ Please provide both --batch and --start values.');
    process.exit(1);
}

console.log(`🔢 Creating ${batch} inspo folders starting at inspo_${String(start).padStart(4, '0')}`);
if (dryRun) {
    console.log('🧪 DRY-RUN mode enabled. No changes will be made.');
}

// === Helper Function ===
function createVarFolderAndFile(parent, varName) {
    const folderPath = path.join(parent, varName);
    const descFile = path.join(folderPath, `${varName}_description.txt`);

    if (dryRun) {
        console.log(`[DRY RUN] Would create folder: ${folderPath}`);
        console.log(`[DRY RUN] Would create file: ${descFile}`);
    } else {
        fs.mkdirSync(folderPath, { recursive: true });
        fs.writeFileSync(descFile, '');
        console.log(`📁 Created folder: ${folderPath}`);
        console.log(`📝 Created file: ${descFile}`);
    }
}

// === Main Loop ===
for (let i = 0; i < batch; i++) {
    const n = start + i;
    const inspoFolder = `inspo_${String(n).padStart(4, '0')}`;
    const fullPath = path.join('.', inspoFolder);

    console.log(`➡ Processing ${inspoFolder}`);

    if (fs.existsSync(fullPath)) {
        console.log(`⚠️ Folder already exists: ${fullPath}`);
    } else {
        if (dryRun) {
            console.log(`[DRY RUN] Would create base folder: ${fullPath}`);
        } else {
            fs.mkdirSync(fullPath, { recursive: true });
            console.log(`📂 Created base folder: ${fullPath}`);
        }
    }

    for (let v = 1; v <= 4; v++) {
        createVarFolderAndFile(fullPath, `var${v}`);
    }
}

if (dryRun) {
    console.log('✅ DRY-RUN complete. No files or folders created.');
} else {
    console.log(`✅ All ${batch} inspo folders created successfully starting at inspo_${String(start).padStart(4, '0')}`);
}

console.log('✨ All set! Happy creating.');

// -----------------------------------------------------------------------------------
// === End of Script ===
// -----------------------------------------------------------------------------------
// This script automates batch creation of MidJourney inspo folders.
// Each inspo folder contains 4 variant subfolders, each with a description file.
// Supports dry-run mode for safe previewing.
// -----------------------------------------------------------------------------------
