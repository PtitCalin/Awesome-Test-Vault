---
id: qst_media-log-pipeline
title: "Build Media Log Pipeline"
type: quest
version: 1.0
status: completed
priority: high
created: 2025-05-10
updated: 2025-05-10
tags: [quest, media, logging, automation, bash, python]
assigned_to: charlie
related: []
parent: ""
rewards:
  - XP: 60
  - Nugget: bash
  - Unlocks: [qst_auto-title-review]
questline: "Vault Automation Series"
skill_tree: "🖥️ Shell + Markup"
summary: >
  Set up an automated media file logging pipeline that records imported files in a structured CSV,
  tagging new entries and preserving original filenames for future curation.
---

## 🎯 Objectives
- [x] Define file/media naming convention
- [x] Create Python script for structured media logging
- [x] Add support for UUID, timestamp, media type, and manual title entry
- [x] Add "new" tag tracking logic
- [x] Write Bash version for portable logging

## 📁 Deliverables
- `file-media-naming-standard.md`
- `generate-media-log.py`
- `generate-media-log.sh`

## 🛠️ Tools Used
- Python (UUID, datetime, CSV)
- Bash (`uuidgen`, `date`, `find`, file I/O)

## 🔄 Next Steps
- Create script to batch edit `descriptive_title` field
- Add JSON output support
- Integrate with dashboard for recent media imports