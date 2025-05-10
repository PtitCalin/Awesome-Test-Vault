# 📌📂 Pinterest Scraper x MidJourney Inspo Organizer — Dev Log
**Last updated:** 2025-05-10

---

## 📌 Project Overview

This project began with a vision: create a seamless, modular system that bridges visual inspiration discovery (via Pinterest) with creative documentation and design workflows inside Obsidian. It would start with scraping curated images from a Pinterest board and end with neatly organized, note-ready folders — structured for creative reflection, aesthetic analysis, and future MidJourney exploration.

The goal?  
A future-proof **Pinterest-to-Inspo pipeline** that supports visual storytelling, worldbuilding, and design systems.

---

## 🚀 Phase 1: Pinterest Scraper Prototype

### ✅ Core Milestone:
- Developed `pinterest-inspo-scraper.py` v1.0–v4.0
- Added:
  - Auto-scrolling
  - Pin image extraction
  - Download logic
  - Delay mechanisms
  - Retry handling

🧠 Outcome: Basic scraper with image harvesting capabilities.

---

## ⚙️ Phase 2: Modularity & Folder Automation

### ✅ Key Features Added:
- Split logic into two scripts:
  - `pinterest-inspo-scraper.py`: handles image scraping
  - `builder_inspo-from-pinterest.py`: handles folder generation and note templates

### 📁 Folder Builder Created:
- Auto-generates `inspo_nnnn` folders
- Includes:
  - ✨ Analysis and Interpretation.md
  - 🏛️ Curatorial Description.md
  - 🖼 Image Description.md (with Pinterest + filename metadata)
  - MidJourney Variations/var1–4 subfolders

📍 Image stays in: `Files and Media > Images > Inspo`  
📍 Notes go in: `Notes > Inspiration > inspo_nnnn`

---

## 📚 Phase 3: Obsidian Integration & Log Architecture

### ✅ Major Additions:
- `🖼 Image Description.md` now includes:
  - Obsidian preview (`![[...]]`)
  - Clickable link (`[View Image](...)`)
  - Pinterest source reference

- Created CSV-based logs:
  - `pinterest_scraper_log.csv`
  - `inspo_structure-builder_log.csv`

🧠 Logs use identical schemas:
```csv
Pinterest URL,Image Filename,Inspo Folder,Title,Timestamp
```

This ensures future data pipelines, dashboards, and documentation views are unified and easy to join.

---

## 🛠️ Tooling Bonus: Markdown Log Exporter

Developed a helper utility:
```bash
python convert_log_to_md.py --log pinterest_scraper_log.csv --output pinterest_scraper_log.md
```

✅ Converts CSV logs into **Obsidian-readable tables**  
✅ Makes logs visually navigable in vault  
✅ Supports both scraper and builder logs

---

## 🌐 Where We Left Off

We completed:
- ✅ A fully functional scraper and builder system (v6.5 and v1.1)
- ✅ CSV log foundation and initial export
- ✅ Modular, reusable scripts
- ✅ Obsidian-first thinking and creative workflow integration

We were just about to:
- Finalize the logging behavior in both scripts to ensure they:
  - Create headers if files don’t exist
  - Append consistently
- Continue expanding documentation and visuals for clarity

---

## 💭 Big Picture Vision

We’re building a **creative operating system** for inspiration:

- **Visual inspiration sourced** from platforms like Pinterest  
- **Automatically catalogued** in your Files & Notes vault  
- **Obsidian-ready documentation** to reflect, analyze, remix, and generate from  
- **Creative rituals + machine-readable structure** in harmony

---

## 🧱 Next Steps (Resuming Momentum)

Here’s what we’re queued to tackle next:

- [x] 🔁 Finalize CSV logging structure in both scripts
- [ ] 📤 Add logic to write headers if missing
1. 🧩 (Optional) Build a log merging tool for unified reporting
2. 🎨 Create a visual pipeline diagram of the system
3. 📚 Extend documentation with usage examples and future upgrade ideas
