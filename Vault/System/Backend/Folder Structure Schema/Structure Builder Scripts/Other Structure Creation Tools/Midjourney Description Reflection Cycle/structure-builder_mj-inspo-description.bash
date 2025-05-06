#!/bin/bash

# -----------------------------------------------------------------------------------
# 🎨 MidJourney Inspo Batch Folder Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./structure-builder_mj-inspo-description.bash --batch <number> --start <start_n> [--dry-run]
# EXAMPLE:
#   ./structure-builder_mj-inspo-description.bash --batch 5 --start 7
# -----------------------------------------------------------------------------------

# === Configuration ===
BASE_PATH="./"   # Change to your preferred root directory

# === Defaults ===
BATCH=1
START=1
DRY_RUN=false

# === Parse Arguments ===
while [[ $# -gt 0 ]]; do
  case "$1" in
    --batch)
      BATCH="$2"
      shift 2
      ;;
    --start)
      START="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo "❌ Unknown argument: $1"
      exit 1
      ;;
  esac
done

# === Sanity Check ===
if [[ -z "$BATCH" || -z "$START" ]]; then
  echo "❌ You must provide --batch and --start values."
  exit 1
fi

echo "🔢 Creating $BATCH inspo folders starting at inspo_$(printf "%04d" "$START")"

if $DRY_RUN; then
  echo "🧪 DRY-RUN mode enabled. No changes will be made."
fi

# === Helper Function ===
create_var_folder_and_file() {
  local parent="$1"
  local var_name="$2"
  local folder_path="$parent/$var_name"
  local desc_file="$folder_path/${var_name}_description.txt"

  if $DRY_RUN; then
    echo "[DRY RUN] Would create folder: $folder_path"
    echo "[DRY RUN] Would create file: $desc_file"
  else
    mkdir -p "$folder_path"
    touch "$desc_file"
    echo "📁 Created folder: $folder_path"
    echo "📝 Created file: $desc_file"
  fi
}

# === Main Loop ===
for (( i=0; i<BATCH; i++ )); do
  N=$((START + i))
  INSPO_FOLDER="inspo_$(printf "%04d" "$N")"
  FULL_PATH="$BASE_PATH/$INSPO_FOLDER"

  echo "➡ Processing $INSPO_FOLDER"

  if [ -d "$FULL_PATH" ]; then
    echo "⚠️ Folder already exists: $FULL_PATH"
  else
    if $DRY_RUN; then
      echo "[DRY RUN] Would create base folder: $FULL_PATH"
    else
      mkdir -p "$FULL_PATH"
      echo "📂 Created base folder: $FULL_PATH"
    fi
  fi

  for v in {1..4}; do
    create_var_folder_and_file "$FULL_PATH" "var$v"
  done

done

# === Completion Message ===
if $DRY_RUN; then
  echo "✅ DRY-RUN complete. No files or folders created."
else
  echo "✅ All $BATCH inspo folders created successfully starting at inspo_$(printf "%04d" "$START")"
fi
echo "✨ All set! Happy creating."
# -----------------------------------------------------------------------------------
# === End of Script ===
# -----------------------------------------------------------------------------------
# This script automates batch creation of MidJourney inspo folders.
# Each inspo folder contains 4 variant subfolders, each with a description file.
# Supports dry-run mode for safe previewing.
# -----------------------------------------------------------------------------------
