# 🧠 Personal Encyclopedia Structure Builder

---

## 📚 About This Script

This script initializes the **Personal Encyclopedia** section of your Obsidian Vault.

It creates a modular and structured hierarchy of **domains** and **topics**, each with its own folder and dashboard, forming the foundation of a lifelong knowledge archive. It includes a sample note for each topic to kickstart content building.

---

### ✅ What It Builds

- 📂 A `/Notes/Personal Encyclopedia` directory
- 🧠 Major knowledge **domains** (e.g., Science & Technology, Philosophy, History)
- 📁 Nested **topic folders** for each domain
- 🧾 Auto-filled `Domain.md` and `Topic.md` dashboard files
- 📝 A sample `Intro to [Topic].md` note for every topic

This creates a scalable and richly linked second brain system.

---

## 🚀 How to Run

⚠️ Reminder: Be sure to edit the VAULT_PATH inside the script to match your local Vault path.

### Normal Mode  
Creates the full directory structure and files:

```bash
./structure-builder_Personal\ Encyclopedia.bash
```

### 🧪 Dry-Run Mode
Preview the output without writing to your file system:

```bash
./structure-builder_Personal\ Encyclopedia.bash --dry-run
```
You'll see a full simulated list of folders and files that would be created — perfect for safely testing.

---

## 🗺️ Structure Generated

```bash
Notes/
└── Personal Encyclopedia/
    ├── Domain A/
    │   ├── Domain A.md
    │   └── Topic A/
    │       ├── Topic A.md
    │       └── Intro to Topic A.md
    ├── Domain B/
    │   ├── Domain B.md
    │   └── Topic B/
    │       ├── Topic B.md
    │       └── Intro to Topic B.md
    └── ...
```
Each file includes consistent YAML headers and content structure:

```yaml
---
title: "Climate Zones and Biomes"
created: 2024-05-01
type: topic
tags: [topic, Geography & Environment]
parent: [[Geography & Environment]]
children: []
---
```

---

## 🧠 How to Extend
To add new domains and topics:

Open the script

Scroll to the declare -A TOPICS section

Add new entries using the existing "Domain"="Topic 1|Topic 2" format

Then rerun the script to generate the new sections!

---

## 💡 Suggested Uses

✅ Build your own lifelong curriculum across disciplines
✅ Tag notes for difficulty, source, and cross-domain relevance
✅ Link your learning to Quests, Projects, Canvas Maps, and more
✅ Serve as the central reference library for your Vault

## ✨ Credits
Script created as part of the [Awesome Test Vault Project]
Structure and taxonomy by PtiCalin 💛
Automation supported by ChatGPT