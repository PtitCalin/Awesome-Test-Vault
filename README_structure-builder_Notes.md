# 🗒️ Notes Structure Builder

---

## 🛠️ About This Script

This script initializes the **Notes** section of your Obsidian Vault for the Awesome Test Vault project.

It creates a **modular structure** that supports:
- 🗓️ Daily notes, planning, and check-ins  
- 📚 PARA-style `Areas`, `Projects`, and `People`  
- 🧠 Journaling workflows and habit tracking  
- 🧾 Meeting logs and reflections  
- 📅 Calendar-based organization

Each folder includes a matching `.md` file pre-filled with a **YAML header** and default content, making every section instantly usable and searchable.

> 🔖 Note: This script does **not** generate the Personal Encyclopedia, which is handled separately.

---

## 🚀 How to Run

⚠️ Reminder: Be sure to edit the VAULT_PATH inside the script to match your local Vault path.

### Normal Mode
Creates all folders and files:

```bash
./structure-builder_Learnings.bash
```
### 🧪 Dry-Run Mode
Preview the actions without modifying your vault:

```bash
./structure-builder_Learnings.bash --dry-run
```
You'll see a full simulated list of folders and files that would be created — perfect for safely testing.

---

## 🗺️ Structure Generated

```bash
Notes/
├── Daily Notes/
│   ├── daily-plan/
│   │   └── daily-plan.md
│   └── journaling-block/
│       └── journaling-block.md
├── Areas/
│   └── Areas.md
├── Projects/
│   └── Projects.md
├── People/
│   └── People.md
├── Calendar/
│   └── Calendar.md
├── Meeting Notes/
│   └── Meeting Notes.md
├── Journaling/
│   ├── Events/
│   │   └── Events.md
│   ├── Goals/
│   ├── Habits/
│   ├── Tasks/
│   ├── Questions/
│   ├── Brain Dump/
│   └── Guided Reflection/
```

Each file includes consistent YAML headers and content structure:

```yaml
---
title: "Habits"
created: 2024-05-01
tags: [note-section, Habits]
---
```

And a clean section intro layout: 

# Habits

This is the **Habits** section of the Notes vault.  
Use this area to organize notes, tasks, reflections, or logs related to "Habits".


--- 

## 🧠 How to Extend

```bash
create_folder_and_file "$NOTES_ROOT/New Section" "New Section"
```
Then rerun the script to generate the new folder and its .md dashboard file.

---

## 💡 Suggested Uses

✅ Use Daily Notes to anchor your focus and reflection
✅ Log events, journaling, and progress in thematic subfolders
✅ Use Meeting Notes for 1:1s, feedback logs, and syncs
✅ Organize Projects and Areas using PARA principles
✅ Use Calendar for time-based views and future planning

---

## ✨ Credits
Script created as part of the Awesome Test Vault Project
Created by PtiCalin 💛
Supported by ChatGPT