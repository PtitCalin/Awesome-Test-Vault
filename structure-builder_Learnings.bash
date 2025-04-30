#!/bin/bash

# -----------------------------------------------------------------------------------
# 🎓 Awesome Test Vault - Learning Structure Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./create_learning_structure_v2_extended.sh             # Normal mode
#   ./create_learning_structure_v2_extended.sh --dry-run    # Dry-run preview
# -----------------------------------------------------------------------------------

# === Configuration ===
VAULT_PATH="/c/Users/charl/OneDrive/Projets/Awesome Test/System/Awesome-Test-Vault"
LEARNING_ROOT="$VAULT_PATH/Learnings"

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

# === Helper Functions ===
create_file() {
  local path="$1"
  local file="$2"
  if $DRY_RUN; then
    echo "[DRY RUN] Would create file: $path/$file.md"
  else
    mkdir -p "$path"
    touch "$path/$file.md"
    echo "📝 Created file: $path/$file.md"
  fi
}

create_dashboard() {
  local path="$1"
  local section_name="$2"
  local tag_name=$(echo "$section_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  if $DRY_RUN; then
    echo "[DRY RUN] Would create dashboard: $path/$section_name.md"
  else
    mkdir -p "$path"
    cat <<EOF > "$path/$section_name.md"
---
title: "$section_name"
created: $(date +%Y-%m-%d)
parent: "$section_name"
tags: [learning-section, $tag_name, dashboard]
---

# $section_name

Welcome to the **$section_name** section! 🚀

- This dashboard is your central hub for everything related to **$section_name**.
- Linked lessons, quests, and resources will appear here as they grow.
EOF
    echo "📋 Created dashboard: $path/$section_name.md"
  fi
}

create_quest() {
  local path="$1"
  local file="$2"
  local section="$3"
  if $DRY_RUN; then
    echo "[DRY RUN] Would create quest file: $path/$file.md"
  else
    mkdir -p "$path"
    cat <<EOF > "$path/$file.md"
---
title: "$file"
date: $(date +%Y-%m-%d)
parent: "$section"
tags: [quest, $section]
difficulty: easy
requirements: []
skills: []
badge: "TBD"
xp: 
progress:
  - [ ] Step 1
  - [ ] Step 2
  - [ ] Step 3
---

# $file

## 🧩 Quest Instructions
Describe the context and purpose of this quest.

## 🛠️ What You'll Do
Describe the main activity or task.

## ✅ Completion Checklist
- [ ] Task 1
- [ ] Task 2

## 🔁 Next Steps
- [ ] Link to follow-up quests
EOF
    echo "🧩 Created quest: $path/$file.md"
  fi
}

# === Learning Management ===
MGMT_ROOT="$LEARNING_ROOT/00 Learning Management"
echo "📋 Creating 00 Learning Management section..."
create_dashboard "$MGMT_ROOT" "00 Learning Management"
create_file "$MGMT_ROOT" "Progress Tracker"
create_file "$MGMT_ROOT" "Skill Tree"
create_file "$MGMT_ROOT" "Curriculum Overview"
create_file "$MGMT_ROOT" "Quest Log"
create_file "$MGMT_ROOT" "Dashboards"

# === Setup
SETUP_ROOT="$LEARNING_ROOT/01 Setup"
echo "📦 Creating 01 Setup section..."
create_dashboard "$SETUP_ROOT" "01 Setup"
create_file "$SETUP_ROOT" "01 - Welcome to the Vault"
create_file "$SETUP_ROOT" "02 - About Obsidian"
create_file "$SETUP_ROOT" "03 - Getting Started on GitHub"
create_file "$SETUP_ROOT" "04 - About the Terminal"
create_file "$SETUP_ROOT" "05 - Git Bash Setup"
create_file "$SETUP_ROOT" "06 - VSCode Setup"
create_quest "$SETUP_ROOT/Quests" "Quest 1 - Setup Your Vault" "01 Setup"

# === GitHub
GITHUB_ROOT="$LEARNING_ROOT/02 GitHub"
echo "📦 Creating 02 GitHub section..."
create_dashboard "$GITHUB_ROOT" "02 GitHub"
create_file "$GITHUB_ROOT" "01 - Intro to GitHub"
create_file "$GITHUB_ROOT" "02 - GitHub Repositories"
create_quest "$GITHUB_ROOT/Quests" "Quest 1 - Create Your First Repository" "02 GitHub"

# === Terminal & File Navigation
TERMINAL_ROOT="$LEARNING_ROOT/03 Terminal & File Navigation"
echo "📦 Creating 03 Terminal & File Navigation section..."
create_dashboard "$TERMINAL_ROOT" "03 Terminal & File Navigation"
create_file "$TERMINAL_ROOT" "01 - Intro to Terminal"
create_file "$TERMINAL_ROOT" "02 - Basic Navigation"
create_file "$TERMINAL_ROOT" "03 - File Creation & Editing"
create_quest "$TERMINAL_ROOT/Quests" "Quest 1 - Hello Bash World" "03 Terminal & File Navigation"

# === Git
GIT_ROOT="$LEARNING_ROOT/04 Git"
echo "📦 Creating 04 Git section..."
create_dashboard "$GIT_ROOT" "04 Git"
create_file "$GIT_ROOT" "01 - Git Basics"
create_file "$GIT_ROOT" "02 - Connecting to GitHub"
create_file "$GIT_ROOT" "03 - Push Your Vault"
create_quest "$GIT_ROOT/Quests" "Quest 1 - Make Your First Commit" "04 Git"

# === Python
PYTHON_ROOT="$LEARNING_ROOT/05 Python"
echo "📦 Creating 05 Python section..."
create_dashboard "$PYTHON_ROOT" "05 Python"
create_file "$PYTHON_ROOT" "01 - Python Basics"
create_file "$PYTHON_ROOT" "02 - Read/Write Files"
create_file "$PYTHON_ROOT" "03 - Python and APIs"
create_quest "$PYTHON_ROOT/Quests" "Quest 1 - Write Your First Script" "05 Python"

# === APIs
APIS_ROOT="$LEARNING_ROOT/06 APIs"
echo "📦 Creating 06 APIs section..."
create_dashboard "$APIS_ROOT" "06 APIs"
create_file "$APIS_ROOT" "01 - What is an API"
create_file "$APIS_ROOT" "02 - Authentication Methods"
create_file "$APIS_ROOT" "03 - API Requests with Python"
create_quest "$APIS_ROOT/Quests" "Quest 1 - Call a Public API" "06 APIs"

# === Data Formats
DATAFORMATS_ROOT="$LEARNING_ROOT/07 Data Formats (YAML, JSON, RSS)"
echo "📦 Creating 07 Data Formats section..."
create_dashboard "$DATAFORMATS_ROOT" "07 Data Formats (YAML, JSON, RSS)"
create_file "$DATAFORMATS_ROOT" "01 - YAML Basics"
create_file "$DATAFORMATS_ROOT" "02 - JSON Parsing"
create_file "$DATAFORMATS_ROOT" "03 - RSS Feeds Explained"
create_quest "$DATAFORMATS_ROOT/Quests" "Quest 1 - Create YAML Frontmatter" "07 Data Formats (YAML, JSON, RSS)"

# === SQL and Databases
SQL_ROOT="$LEARNING_ROOT/08 SQL and Databases"
echo "📦 Creating 08 SQL and Databases section..."
create_dashboard "$SQL_ROOT" "08 SQL and Databases"
create_file "$SQL_ROOT" "01 - SQL Basics"
create_file "$SQL_ROOT" "02 - Creating Databases"
create_file "$SQL_ROOT" "03 - Querying Data"
create_quest "$SQL_ROOT/Quests" "Quest 1 - Write Your First SQL Query" "08 SQL and Databases"

# === Completion ===
if $DRY_RUN; then
  echo "✅ DRY-RUN complete. No files or folders created."
else
  echo "✅ Extended Learning structure created successfully at: $LEARNING_ROOT"
fi
echo "🎉 All folders and files for 'Learnings' have been scaffolded!"
echo "📂 Structure created successfully at: $LEARNING_ROOT "
echo "🚀 Happy learning! 🎓"
# -----------------------------------------------------------------------------------
# This script is designed to create a structured directory for managing learning
# resources in an Obsidian vault. It includes folders for various topics, each with
# a dashboard file for organization and documentation purposes.
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