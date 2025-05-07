#!/usr/bin/env python3

# -----------------------------------------------------------------------------------
# 📂 MidJourney Inspo Folder Builder v1.0
# -----------------------------------------------------------------------------------
# SCRIPT NAME:
#   builder_inspo-from-pinterest.py
#
# PURPOSE:
#   Creates an inspo folder for a Pinterest image following the new structure:
#
#   • Image stays in: Files and Media > Images > Inspo
#   • Notes folder created in: Notes > Inspiration > inspo_nnnn
#   • Notes folder contains:
#       - ✨ Analysis and Interpretation.md
#       - 🏛️ Curatorial Description.md
#       - 🖼 Image Description.md (with reference to the image & Pinterest URL)
#       - MidJourney Variations/var1-4/var_description.md
#
# HOW THIS SCRIPT IS USED:
#   This script is called automatically by the Pinterest scraper after each image download.
#   It can also be used manually for organizing additional inspo images.
#
# ARGUMENTS:
#   --image : The filename of the image (must already be in the Inspo image folder)
#   --title : Optional title for the inspo (defaults to "Untitled")
#   --url   : Optional Pinterest URL for reference
#   --dry-run : If set, no changes will be made (for preview/testing)
#
# -----------------------------------------------------------------------------------

import os
import re
from datetime import datetime

# -----------------------------------------------------------------------------------
# === USER CONFIGURATION ===
# -----------------------------------------------------------------------------------

# Where to create the inspo notes folders:
BASE_PATH_NOTES = r"C:\Users\charl\OneDrive\Projets\Awesome Test\System\Awesome-Test-Vault\VAULT\Notes\Inspiration"

# Where the images are stored:
BASE_PATH_IMAGES = r"C:\Users\charl\OneDrive\Projets\Awesome Test\System\Awesome-Test-Vault\VAULT\Files and Media\Images\Inspo"

# Where to write the logs:
LOG_PATH = r"C:\Users\charl\OneDrive\Projets\Awesome Test\System\Awesome-Test-Vault\VAULT\System\Backend\Logs\Inspo File Scrape and Organization Log\inspo_organizer.log"

# Notes files to create:
INSPO_FILES = [
    "✨ Analysis and Interpretation.md",
    "🏛️ Curatorial Description.md",
    "🖼 Image Description.md"
]

# Variations folder name:
VARIATIONS_FOLDER = "MidJourney Variations"

# -----------------------------------------------------------------------------------
# === CORE FUNCTION ===
# -----------------------------------------------------------------------------------

def create_inspo_folder(image_filename, title="Untitled", pinterest_url="N/A", dry_run=False):
    """
    Creates a new inspo folder in the Notes > Inspiration structure.
    Links to the provided image (must be in the BASE_PATH_IMAGES folder).

    Returns the inspo folder name (e.g., inspo_0001).
    """

    # 1️⃣ Auto-detect next inspo number:
    existing = [d for d in os.listdir(BASE_PATH_NOTES) if re.match(r"inspo_\d{4}", d)]
    existing_numbers = [
        int(re.findall(r"inspo_(\d{4})", name)[0]) for name in existing
    ] if existing else []

    next_number = max(existing_numbers) + 1 if existing_numbers else 1
    folder_name = f"inspo_{next_number:04d}"
    full_path = os.path.join(BASE_PATH_NOTES, folder_name)

    print(f"➡ Creating inspo folder: {folder_name}")
    print(f"   📍 Notes folder path: {full_path}")
    print(f"   📷 Image filename: {image_filename}")

    # 2️⃣ Create base folder:
    if dry_run:
        print(f"[DRY RUN] Would create folder: {full_path}")
    else:
        os.makedirs(full_path, exist_ok=True)
        print(f"📂 Created folder: {full_path}")

    # 3️⃣ Create the core markdown files:
    for filename in INSPO_FILES:
        filepath = os.path.join(full_path, filename)
        if dry_run:
            print(f"[DRY RUN] Would create file: {filepath}")
        else:
            with open(filepath, "a") as f:
                if filename == "🖼 Image Description.md":
                    # Add image reference + Pinterest URL + Obsidian smart links:
                    image_reference = (
                        f"**Inspiration Image:** {image_filename}\n"
                        f"**Pinterest URL:** {pinterest_url}\n\n"
                        f"**Obsidian Image Link (embedded preview):**\n"
                        f"![[Files and Media/Images/Inspo/{image_filename}]]\n\n"
                        f"**Obsidian Image Link (clickable link):**\n"
                        f"[View Image](Files and Media/Images/Inspo/{image_filename})\n"
                    )
                    f.write(image_reference)
            print(f"📝 Created file: {filepath}")

    # 4️⃣ Create the MidJourney Variations structure:
    variations_base = os.path.join(full_path, VARIATIONS_FOLDER)
    for v in range(1, 5):
        var_name = f"var{v}"
        var_folder = os.path.join(variations_base, var_name)
        desc_file = os.path.join(var_folder, f"{var_name}_description.md")

        if dry_run:
            print(f"[DRY RUN] Would create folder: {var_folder}")
            print(f"[DRY RUN] Would create file: {desc_file}")
        else:
            os.makedirs(var_folder, exist_ok=True)
            open(desc_file, "a").close()
            print(f"📁 Created folder: {var_folder}")
            print(f"📝 Created file: {desc_file}")

    # 5️⃣ Log the creation:
    log_entry = (
        f"{datetime.now().isoformat()} | Created {folder_name} | "
        f"Image: {image_filename} | Title: {title} | Pinterest URL: {pinterest_url}\n"
    )

    if dry_run:
        print(f"[DRY RUN] Would write to log: {log_entry}")
    else:
        os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
        with open(LOG_PATH, "a") as log_file:
            log_file.write(log_entry)
        print(f"🗒 Logged action to: {LOG_PATH}")

    print(f"✅ inspo folder {folder_name} created successfully.")
    return folder_name

# -----------------------------------------------------------------------------------
# === CLI SUPPORT ===
# -----------------------------------------------------------------------------------

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="📂 MidJourney Inspo Folder Builder v1.0 - Notes & Media Split Edition"
    )
    parser.add_argument(
        "--image", type=str, required=True,
        help="Filename of the image already in the Inspo image folder"
    )
    parser.add_argument("--title", type=str, default="Untitled", help="Title for the inspo")
    parser.add_argument("--url", type=str, default="N/A", help="Pinterest URL")
    parser.add_argument(
        "--dry-run", action="store_true",
        help="Preview actions without making changes"
    )

    args = parser.parse_args()

    create_inspo_folder(
        image_filename=args.image,
        title=args.title,
        pinterest_url=args.url,
        dry_run=args.dry_run
    )

# -----------------------------------------------------------------------------------
# === END OF SCRIPT ===
# -----------------------------------------------------------------------------------
