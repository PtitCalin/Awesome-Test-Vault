# 📁 Template Naming Standard

This document defines the official naming convention for all **template files** in the Awesome Test Vault. These rules ensure consistency, clarity, and ease of automation when working with reusable structures such as quest templates, metadata snippets, or system scaffolds.

---

## 📐 General Format

> **`[abbrev]_[name-of-template].md`**

- Use **lowercase** only
- Separate the type abbreviation and the name with an **underscore**
- Use **kebab-case** for the name portion
- Append optional suffixes like `-v1.2`, `-draft`, or `-metadata.yaml.md` for specific use cases

---

## 🔠 Abbreviation Table: Template Types

| Abbrev | Template Type      | Use Case                                 | Example Filename                        |
|--------|--------------------|-------------------------------------------|-----------------------------------------|
| `qst`  | Quest Template      | Reusable quest structures                 | `qst_bash-inspo-builder.md`             |
| `lsn`  | Lesson Template     | Educational walkthrough templates         | `lsn_terminal-basics.md`                |
| `tpl`  | Generic Template    | Reusable logic, text, or structure blocks | `tpl_dataview-query-block.md`           |
| `ymd`  | YAML Metadata Block | YAML snippet embedded in Markdown         | `ymd_qst-metadata.yaml.md`              |
| `sys`  | System Template     | Naming conventions, setup scaffolds       | `sys_template-naming-guidelines.md`     |
| `log`  | Log Template        | Structured daily/weekly logging formats   | `log_daily-entry.md`                    |
| `prj`  | Project Template    | Project scaffolding templates             | `prj_midjourney-scraper-pipeline.md`    |
| `doc`  | Documentation       | Vault- or repo-wide reference templates   | `doc_github-issue-workflow.md`          |

---

## 🏷️ Optional Suffixes

| Suffix             | Meaning                                   | Example                                 |
|--------------------|-------------------------------------------|-----------------------------------------|
| `-v1.2`            | Versioned file                            | `tpl_lesson-outline-v1.2.md`            |
| `-draft`           | Work in progress                          | `qst_data-scraper-draft.md`             |
| `-archive`         | Archived/Deprecated template              | `lsn_old-yaml-guide-archive.md`         |
| `-metadata.yaml.md`| YAML metadata block embedded in markdown  | `ymd_lesson-template-metadata.yaml.md`  |

---

## ⚡ Filtering Tips (for CLI and Vault Plugins)

- List all quest templates:
  ```bash
  ls qst_*
  ```

- Show all system-related templates:
  ```bash
  ls sys_*
  ```

- Find all YAML metadata blocks:
  ```bash
  ls ymd_*.yaml.md
  ```

---

## ✅ Summary

This naming system balances clarity, brevity, and automation-friendliness. All reusable templates within the vault should follow this structure to ensure consistency across contributors and tools.