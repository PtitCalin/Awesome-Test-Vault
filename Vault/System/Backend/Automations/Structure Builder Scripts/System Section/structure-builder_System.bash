#!/bin/bash

# -----------------------------------------------------------------------------------
# ⚙️ Awesome Test Vault - System Section Structure Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./structure-builder_System.bash             # Normal mode
#   ./structure-builder_System.bash --dry-run   # Preview mode
# -----------------------------------------------------------------------------------

# === Configuration ===
VAULT_PATH="/c/Users/charl/OneDrive/Projets/Awesome Test/System/Awesome-Test-Vault"
SYSTEM_ROOT="$VAULT_PATH/System"

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🧪 DRY-RUN mode enabled. No changes will be made."
fi

if [ ! -d "$VAULT_PATH" ]; then
  echo "❌ Vault path not found: $VAULT_PATH"
  exit 1
fi

# === Helper Function ===
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
tags: [system, ${path##*/}, $name]
type: system-note
---

# $name

This is the **$name** note inside the System section.
EOF
    echo "📁 Created: $path"
    echo "📝 Created file: $path/$name.md"
  fi
}

# === System Structure ===

# Dashboards
create_folder_and_file "$SYSTEM_ROOT/Dashboards" "Homepage"
create_folder_and_file "$SYSTEM_ROOT/Dashboards" "Vault Map"
create_folder_and_file "$SYSTEM_ROOT/Dashboards" "Curriculum"
create_folder_and_file "$SYSTEM_ROOT/Dashboards/Dashboards" "Dashboard Index"
create_folder_and_file "$SYSTEM_ROOT/Dashboards/Dashboards" "Personal Dashboard"
create_folder_and_file "$SYSTEM_ROOT/Dashboards/Dashboards" "Project Dashboard"
create_folder_and_file "$SYSTEM_ROOT/Dashboards/Dashboards" "Learning Dashboard"

# Templates
TEMPLATES=(
  "Templates"
  "New Brain Dump Template"
  "New Event Template"
  "General Note Template"
  "New Meeting Note Template"
  "New Goal Template"
  "New Person Template"
  "New Project Template"
  "Reflection Template"
  "Task Template"
  "Recurring Task Template"
  "New Quest Template"
  "New Lesson Template"
)
for t in "${TEMPLATES[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Templates" "$t"
done

# Meta
create_folder_and_file "$SYSTEM_ROOT/Meta" "Vault Philosophy"
create_folder_and_file "$SYSTEM_ROOT/Meta/Naming Conventions" "File Naming Conventions"
create_folder_and_file "$SYSTEM_ROOT/Meta/Naming Conventions" "Folder Naming Conventions"
create_folder_and_file "$SYSTEM_ROOT/Meta" "Tags Glossary"
create_folder_and_file "$SYSTEM_ROOT/Meta/Metadata Standards" "YAML Metadata Standards"
create_folder_and_file "$SYSTEM_ROOT/Meta/Metadata Standards" "Tags Metadata Standards"
create_folder_and_file "$SYSTEM_ROOT/Meta/Metadata Standards" "Links Metadata Standards"

# Logs
LOGS=(
  "Vault Setup Log"
  "Vault Maintenance Log"
  "Vault Backup Log"
  "Dev Journal"
  "Vault Change Log"
  "Content Roadmap"
  "Automation Log"
  "Plugin Log"
  "Plugin Development Log"
)
for l in "${LOGS[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Logs" "$l"
done

# Automations
AUTOMATIONS=(
  "Automation Index"
  "Script Registry"
  "Cron Schedule"
  "Automation Documentation"
  "Automation Testing"
)
for a in "${AUTOMATIONS[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Automations" "$a"
done

# Plugins
PLUGINS=(
  "Enabled Plugins"
  "Plugin Configuration Notes"
  "Plugin Wish List"
  "Plugin Development"
  "Plugin API"
  "Plugin Testing"
  "Plugin Documentation"
  "Plugin Compatibility"
)
for p in "${PLUGINS[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Plugins" "$p"
done

# Backend
BACKEND=(
  "Obsidian Settings"
  "GitHub Sync"
  "Data Models"
  "Folder Structure Schema"
  "Vault Export Settings"
)
for b in "${BACKEND[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Backend" "$b"
done

# Frontend
FRONTEND=(
  "UI Themes"
  "Canvas Maps"
  "Custom Icons"
  "Iconography"
  "Color Schemes"
  "Typography"
  "Custom CSS"
  "Custom Views"
  "UX Design Principles"
  "User Experience Testing"
)
for f in "${FRONTEND[@]}"; do
  create_folder_and_file "$SYSTEM_ROOT/Frontend" "$f"
done

# === Completion ===
if $DRY_RUN; then
    echo "✅ DRY-RUN complete. No files or folders created."
else
    echo "✅ System section structure created successfully at: $SYSTEM_ROOT"
fi
    echo "🔍 Check the structure and adjust as needed."
# End of script
# -----------------------------------------------------------------------------------
# This script creates a structured folder and file system for the System section of the Awesome Test Vault.
# It includes dashboards, templates, meta information, logs, automations, plugins, backend, and frontend sections.
# Each section contains relevant notes and templates to facilitate organization and access.
# The script can be run in dry-run mode to preview changes without making any modifications.
# -----------------------------------------------------------------------------------
# This script is intended for educational purposes and should be used with caution.
# The author is not responsible for any data loss or corruption that may occur
# Always back up your data before running scripts that modify file systems.
# Use at your own risk.
# -----------------------------------------------------------------------------------