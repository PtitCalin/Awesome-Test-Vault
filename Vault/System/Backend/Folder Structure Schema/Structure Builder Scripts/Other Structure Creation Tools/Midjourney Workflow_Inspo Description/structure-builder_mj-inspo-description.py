#!/usr/bin/env python3

# -----------------------------------------------------------------------------------
# 🎨 MidJourney Inspo Batch Folder Builder - Python Version
# -----------------------------------------------------------------------------------
# USAGE:
#   python mj_inspo_builder.py --batch 5 --start 7                # Normal mode
#   python mj_inspo_builder.py --batch 5 --start 7 --dry-run      # Preview only, no changes
#
# EXAMPLE:
#   python mj_inspo_builder.py --batch 3 --start 42
# -----------------------------------------------------------------------------------

import os
import argparse

# === Configuration ===
BASE_PATH = "./"  # Change this to your preferred root directory

# -----------------------------------------------------------------------------------
# === Argument Parsing ===
# -----------------------------------------------------------------------------------
parser = argparse.ArgumentParser(
    description="🎨 MidJourney Inspo Batch Folder Builder - Python Version"
)
parser.add_argument("--batch", type=int, required=True, help="Number of inspo folders to create")
parser.add_argument("--start", type=int, required=True, help="Starting number for folder naming")
parser.add_argument("--dry-run", action="store_true", help="Preview actions without making changes")

args = parser.parse_args()

batch = args.batch
start = args.start
dry_run = args.dry_run

print(f"🔢 Creating {batch} inspo folders starting at inspo_{start:04d}")

if dry_run:
    print("🧪 DRY-RUN mode enabled. No changes will be made.")

# -----------------------------------------------------------------------------------
# === Helper Function ===
# -----------------------------------------------------------------------------------

def create_var_folder_and_file(parent, var_name):
    """
    Creates a variant folder and an empty description file inside it.
    """
    folder_path = os.path.join(parent, var_name)
    desc_file = os.path.join(folder_path, f"{var_name}_description.txt")

    if dry_run:
        print(f"[DRY RUN] Would create folder: {folder_path}")
        print(f"[DRY RUN] Would create file: {desc_file}")
    else:
        os.makedirs(folder_path, exist_ok=True)
        open(desc_file, "a").close()
        print(f"📁 Created folder: {folder_path}")
        print(f"📝 Created file: {desc_file}")

# -----------------------------------------------------------------------------------
# === Main Loop ===
# -----------------------------------------------------------------------------------

for i in range(batch):
    n = start + i
    inspo_folder = f"inspo_{n:04d}"
    full_path = os.path.join(BASE_PATH, inspo_folder)

    print(f"➡ Processing {inspo_folder}")

    if os.path.exists(full_path):
        print(f"⚠️ Folder already exists: {full_path}")
    else:
        if dry_run:
            print(f"[DRY RUN] Would create base folder: {full_path}")
        else:
            os.makedirs(full_path, exist_ok=True)
            print(f"📂 Created base folder: {full_path}")

    # Create var1 to var4 folders with description files
    for v in range(1, 5):
        var_name = f"var{v}"
        create_var_folder_and_file(full_path, var_name)

# -----------------------------------------------------------------------------------
# === Completion Message ===
# -----------------------------------------------------------------------------------
if dry_run:
    print("✅ DRY-RUN complete. No files or folders created.")
else:
    print(
        f"✅ All {batch} inspo folders created successfully starting at inspo_{start:04d}"
    )

print("✨ All set! Happy creating.")

# -----------------------------------------------------------------------------------
# === End of Script ===
# -----------------------------------------------------------------------------------
# This script automates batch creation of MidJourney inspo folders.
# Each inspo folder contains 4 variant subfolders, each with a description file.
# Supports dry-run mode to preview the actions without making any changes.
#
# Educational and creative use only. Use at your own risk.
# -----------------------------------------------------------------------------------
