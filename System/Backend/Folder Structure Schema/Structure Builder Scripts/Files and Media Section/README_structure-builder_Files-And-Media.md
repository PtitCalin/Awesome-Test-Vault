# 📁 Files and Media Structure Builder

---

## 📚 About This Script

This script initializes the **Files and Media** section of your Obsidian Vault.

It automatically generates a modular structure for organizing **non-native note content** such as images, PDFs, audio recordings, videos, and web captures.

The script creates:
- 📂 A dedicated `/Files and Media` directory
- 🗂️ Subfolders for different content types
- 🧾 Dashboard `.md` files with basic YAML
- 🧠 A clean system for integrating media with your notes, projects, and quests

---

## 🚀 How to Run

⚠️ Reminder: Be sure to edit the VAULT_PATH inside the script to match your local Vault path.

### ✅ Normal Mode  
Create all folders and dashboards:

```bash
./structure-builder_Files-And-Media.bash
```
### 🧪 Dry-Run Mode
Preview the actions without modifying your vault:
```bash
./structure-builder_Files-And-Media.bash --dry-run
```
You'll see a full simulated list of folders and files that would be created — perfect for safely testing.

---

## 🗺️ Structure Generated

```bash
Files and Media/
├── Files and Media.md
├── Images/
│   └── Images.md
├── Documents/
│   └── Documents.md
├── Audio/
│   └── Audio.md
├── Video/
│   └── Video.md
├── Web Clippings/
│   └── Web Clippings.md
├── Other Media/
│   └── Other Media.md
```

Each .md file contains default YAML metadata:

```yaml
---
title: "Audio"
created: 2024-05-01
tags: [media-section, Audio]
---

```

And a simple layout:

# Audio

This is the **Audio** section of the Files and Media vault.  
Use this area to organize and store sound files, recordings, and musical references.

---

## 💡 Suggested Uses

✅ Store research PDFs, interview recordings, screenshots, slides, etc.

✅ Add frontmatter fields like source, format, project, or linked_note for each item

✅ Embed this section into your global Vault navigation for quick media access

---

## 🧠 How to Extend
Want to add a new media category?

Open the script. In the the # === Create Files and Media Section === add:

```bash
create_folder_and_dashboard "$MEDIA_ROOT/[Folder Name]" "[Dashboard Name]"
```
💡Folder Name = Dashboard Name


---

## ✨ Credits
Script created as part of the [Awesome Test Vault Project].
Vault structure by PtiCalin 💛
Supported by ChatGPT