#!/bin/bash

# -----------------------------------------------------------------------------------
# 📁 Awesome Test Vault - Files and Media Structure Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./files-and-media-builder.sh             # Normal mode
#   ./files-and-media-builder.sh --dry-run   # Preview only, no changes
# -----------------------------------------------------------------------------------

# === Configuration ===
VAULT_PATH="/c/Users/charl/OneDrive/Projets/Awesome Test/System/Awesome-Test-Vault"
MEDIA_ROOT="$VAULT_PATH/Files and Media"

# === Dry Run Mode ===
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🧪 DRY-RUN mode enabled. No changes will be made."
fi

# === Safety Check ===
if [ ! -d "$VAULT_PATH" ]; then
  echo "❌ Vault path not found: $VAULT_PATH"
  exit 1
fi

# === Helper Function ===
create_folder_and_dashboard() {
  local path="$1"
  local name="$2"
  if $DRY_RUN; then
    echo "[DRY RUN] Would create folder: $path"
    echo "[DRY RUN] Would create dashboard: $path/$name.md"
  else
    mkdir -p "$path"
    cat <<EOF > "$path/$name.md"
---
title: "$name"
created: $(date +%Y-%m-%d)
tags: [media-section, $name]
---

# $name

This is the **$name** section of the Files and Media vault.
Use this area to organize and store non-Obsidian-native content.
EOF
    echo "📁 Created folder and dashboard: $path/$name.md"
  fi
}

# === Create Files and Media Section ===
echo "📂 Creating Files and Media directory structure..."
create_folder_and_dashboard "$MEDIA_ROOT" "Files and Media"
create_folder_and_dashboard "$MEDIA_ROOT/Images" "Images"
create_folder_and_dashboard "$MEDIA_ROOT/Documents" "Documents"
create_folder_and_dashboard "$MEDIA_ROOT/Audio" "Audio"
create_folder_and_dashboard "$MEDIA_ROOT/Video" "Video"
create_folder_and_dashboard "$MEDIA_ROOT/Web Clippings" "Web Clippings"
create_folder_and_dashboard "$MEDIA_ROOT/Other Media" "Other Media"

# === Completion Message ===
if $DRY_RUN; then
  echo "✅ DRY-RUN complete. No files or folders created."
else
  echo "✅ Files and Media structure created successfully at: $MEDIA_ROOT"
fi
# === End of Script ===
# -----------------------------------------------------------------------------------
# This script is designed to create a structured directory for managing files and media
# in an Obsidian vault. It includes folders for images, documents, audio, video,
# web clippings, and other media types. Each folder contains a dashboard file for
# organization and documentation purposes.
# The script can be run in dry-run mode to preview changes without making any
# modifications. It includes safety checks to ensure the vault path exists before
# proceeding with folder creation. The script is designed to be user-friendly and
# informative, providing feedback on the actions taken.
# -----------------------------------------------------------------------------------
# This script is intended for educational purposes and should be used with caution.
# Always back up your data before running scripts that modify file structures.
# The author is not responsible for any data loss or corruption that may occur.
# Use at your own risk.
# -----------------------------------------------------------------------------------