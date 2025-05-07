---
title: "YAML Metadata Standards"
created: 2025-04-29
tags: [system, Metadata Standards, YAML Metadata Standards]
type: system-note
---

# YAML Metadata Standards

This is the **YAML Metadata Standards** note inside the System section.

# 🗂 Awesome Test Vault — YAML Metadata Standards (v1.0)

_Last updated: 2025-05-06_

## 🎯 Purpose

This document defines the official **YAML metadata standard** for the Awesome Test Vault.  
All notes, lessons, quests, templates, and other content types should follow this structure for consistency, scalability, and compatibility with Obsidian plugins and Dataview queries.

## 🔖 General Principles

- ✅ **Consistency over complexity** — every note uses a predictable structure.
- ✅ **Expandable** — modular fields can be added as needed.
- ✅ **Readable and human-friendly** — easy to write and review.
- ✅ **Plugin-compatible** — especially Dataview, Templater, and DB Folder.

---

## 📝 Universal YAML Structure

_This block should appear in every note._

```yaml

id: vault-ID-optional
title: 
type: 
version: 1.0
status: 
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: 
aliases: 

```

| Field     | Purpose                                                       |
| --------- | ------------------------------------------------------------- |
| `id`      | Optional unique ID if needed for queries or cross-referencing |
| `title`   | Title of the note (overrides filename in queries)             |
| `type`    | Content type (lesson, quest, MOC, template, note, etc.)       |
| `version` | YAML metadata schema version (starts at 1.0)                  |
| `status`  | Draft / In progress / Complete / Archived                     |
| `created` | Creation date                                                 |
| `updated` | Last modified date                                            |
| `tags`    | Standard Obsidian tags (lowercase, hyphen-separated)          |
| `aliases` | Alternate titles or search terms                              |

## 🌳 Specialized Fields by Note Type

Use these only for applicable note types.


## 🔗 Related Standards

- **Quest Metadata Template**
    
- **Lesson Metadata Template**
    
- **Template Naming Conventions**
    
- **Tagging Guidelines**
    

---

## 🏷 Change Log

| Version | Date       | Notes                              |
| ------- | ---------- | ---------------------------------- |
| 1.0     | 2025-05-06 | Initial YAML standard established. |
