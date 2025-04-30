#!/bin/bash

# -----------------------------------------------------------------------------------
# 🗒️ Awesome Test Vault - Notes Section Structure Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./structure-builder_Notes.bash             # Normal mode
#   ./structure-builder_Notes.bash --dry-run   # Preview mode
# -----------------------------------------------------------------------------------

# === Configuration ===
VAULT_PATH="/c/Users/charl/OneDrive/Projets/Awesome Test/System/Awesome-Test-Vault"
NOTES_ROOT="$VAULT_PATH/Notes"

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🧪 DRY-RUN mode enabled. No changes will be made."
fi

if [ ! -d "$VAULT_PATH" ]; then
  echo "❌ Vault path not found: $VAULT_PATH"
  exit 1
fi

# === Helper Functions ===
create_folder_and_file() {
  local path="$1"
  local name="$2"
  if $DRY_RUN; then
    echo "[DRY RUN] Would create folder: $path"
    echo "[DRY RUN] Would create file: $path/$name.md"
  else
    mkdir -p "$path"
    cat <<EOF > "$path/$name.md"
---
title: "$name"
created: $(date +%Y-%m-%d)
tags: [note-section, $name]
---

# $name

This is the **$name** section of the Notes vault.
Use this area to organize notes, tasks, reflections, or logs related to "$name".
EOF
    echo "📁 Created: $path"
    echo "📝 Created file: $path/$name.md"
  fi
}

# === Create Notes Section ===
echo "🛠️ Creating core Notes structure..."
create_folder_and_file "$NOTES_ROOT" "Notes"

# Daily Notes
create_folder_and_file "$NOTES_ROOT/Daily Notes/daily-plan" "daily-plan"
create_folder_and_file "$NOTES_ROOT/Daily Notes/journaling-block" "journaling-block"

# PARA Style
create_folder_and_file "$NOTES_ROOT/Areas" "Areas"
create_folder_and_file "$NOTES_ROOT/Projects" "Projects"
create_folder_and_file "$NOTES_ROOT/People" "People"

# Other Structural Sections
create_folder_and_file "$NOTES_ROOT/Calendar" "Calendar"
create_folder_and_file "$NOTES_ROOT/Meeting Notes" "Meeting Notes"

# Journaling System
create_folder_and_file "$NOTES_ROOT/Journaling/Events" "Events"
create_folder_and_file "$NOTES_ROOT/Journaling/Goals" "Goals"
create_folder_and_file "$NOTES_ROOT/Journaling/Habits" "Habits"
create_folder_and_file "$NOTES_ROOT/Journaling/Tasks" "Tasks"
create_folder_and_file "$NOTES_ROOT/Journaling/Questions" "Questions"
create_folder_and_file "$NOTES_ROOT/Journaling/Brain Dump" "Brain Dump"
create_folder_and_file "$NOTES_ROOT/Journaling/Guided Reflection" "Guided Reflection"

# === Completion ===
if $DRY_RUN; then
  echo "✅ DRY-RUN complete. No files or folders created."
else
  echo "✅ Notes section structure created successfully at: $NOTES_ROOT"
fi
echo "📂 Structure:"
tree -L 2 "$NOTES_ROOT" --noreport
echo "🔍 Check the structure and adjust as needed."

# === End of Script ===
# -----------------------------------------------------------------------------------
# This script is designed to create a structured folder and file system for the Notes section of the Awesome Test Vault.
# It includes Daily Notes, PARA-style organization, and a journaling system.
# The script can be run in dry-run mode to preview changes before applying them.
# -----------------------------------------------------------------------------------
# This script is intended for educational purposes and should be used with caution.
# Always back up your data before running scripts that modify file structures.
# The author is not responsible for any data loss or corruption that may occur.
# Use at your own risk.
# -----------------------------------------------------------------------------------