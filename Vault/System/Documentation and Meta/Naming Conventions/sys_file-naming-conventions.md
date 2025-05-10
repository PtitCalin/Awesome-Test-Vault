---
id: sys_file-naming-conventions
title: "File & Media Naming Conventions"
created: 2025-04-29
updated: 2025-05-10
type: system-note
version: 1.1
status: active
tags: [system, naming, conventions, file-management, media-logging]
aliases: ["file naming", "media naming", "vault file structure"]
category: system
related: [sys_template-naming-guidelines, qst_media-log-pipeline]
summary: >
  Guidelines for naming and managing files and media inside the vault. 
  Emphasizes preserving original filenames, using structured folders, and 
  leveraging automated logging to maintain metadata without manual renaming.
---

# 📂 File & Media Naming Conventions

To maintain consistency and reduce file management overhead:

## ✅ Naming Guidelines
- **Do not manually rename** imported media or files.
- Place them in the correct folder based on type (`images/`, `pdfs/`, `audio/`, etc.).
- A script will log metadata automatically (see below).

## 🧾 Logging System Overview

All imported files are registered in a `media_log.csv` using:
- A unique **UUID**
- A **timestamp** of import
- Their **original filename**
- An editable **descriptive title**
- Automatically assigned **media type** (based on folder)
- A **path**
- A `is_new` flag to indicate fresh entries

> See Quest: [[qst_media-log-pipeline]]  
> Scripts: `generate-media-log.py`, `generate-media-log.sh`

## 📘 Related Conventions
- [[sys_template-naming-guidelines]] – for reusable template naming
- [[sys_tagging-guidelines]] – for tag structure used in file metadata

