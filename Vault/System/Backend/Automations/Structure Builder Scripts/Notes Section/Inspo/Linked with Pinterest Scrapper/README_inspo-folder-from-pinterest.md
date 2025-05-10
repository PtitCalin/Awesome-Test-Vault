# 📂 MidJourney Inspo Folder Builder

**Script Name:** `builder_inspo-from-pinterest.py`  
**Version:** v1.0  
**Author:** PtiCalin & ChatGPT  
**Purpose:** Automatically creates a full inspo folder structure for a Pinterest image, including Obsidian-compatible links and note templates.

---

## 📝 Overview

This script:

- Automatically assigns a new `inspo_nnnn` folder number.
- Creates a note folder under `Notes > Inspiration`.
- Writes standard markdown files:
    - ✨ Analysis and Interpretation.md
    - 🏛️ Curatorial Description.md
    - 🖼 Image Description.md *(with image reference, Pinterest URL, and Obsidian links)*.
- Creates a `MidJourney Variations` subfolder with `var1` to `var4` folders, each with a description.md file.
- Logs the creation event.
- Supports **dry run mode** for testing.

---

## 📁 Folder Structure Created

```plaintext
Notes
└── Inspiration
    └── inspo_0001
        ├── ✨ Analysis and Interpretation.md
        ├── 🏛️ Curatorial Description.md
        ├── 🖼 Image Description.md
        └── MidJourney Variations
            ├── var1 / var1_description.md
            ├── var2 / var2_description.md
            ├── var3 / var3_description.md
            ├── var4 / var4_description.md
```
🖼 The related image stays in:
Files and Media > Images > Inspo > image_filename.jpg

## 🔗 Obsidian Links
The 🖼 Image Description.md will include:

```markdown
**Inspiration Image:** image_filename.jpg
**Pinterest URL:** https://pinterest.com/your-pin

**Obsidian Image Link (embedded preview):**
![[Files and Media/Images/Inspo/image_filename.jpg]]

**Obsidian Image Link (clickable link):**
[View Image](Files and Media/Images/Inspo/image_filename.jpg)


# Description of the image:



```
## ⚙️ Usage
1. **Install Required Libraries**: Ensure you have the required libraries installed. You can do this using pip:
   ```bash
   pip install requests beautifulsoup4
   ```
2. **Run the Script**: Execute the script in your Python environment. You can run it directly from the command line or within an IDE.
   ```bash
    python builder_inspo-from-pinterest.py
    ```
### Optional arguments:
| Argument  | Description                                                                         |
| --------- | ----------------------------------------------------------------------------------- |
| --image   | **Required.** Filename of the image (must already exist in the Inspo image folder). |
| --title   | Title for the inspo folder. Defaults to "Untitled".                                 |
| --url     | Pinterest URL for reference.                                                        |
| --dry-run | Preview actions without making any changes.                                         |

## 🔄 Integration
This script is designed to be called automatically by the Pinterest Scraper v1.0 after each image download.

[ Pinterest Board ]
    ↓
[ Scraper ]
    ↓
[ Downloads image → Files and Media > Images > Inspo ]
    ↓
[ Calls Folder Builder ]
    ↓
[ Creates Notes > Inspiration > inspo_nnnn folder ]
    ↓
[ Links image + Pinterest URL in Obsidian-friendly format ]
    ↓
[ Logs everything ]


It can also be run manually to add additional inspo folders for existing images.

## 📜 Logs
All actions are logged to:
`VAULT/System/Backend/Folder Structure Schema/Structure Builder Scripts/Other Structure Creation Tools/Inspo Folder - MidJourney Image Description Workflow/logs.txt`

## ✅ Features Summary

| Feature                          | Status |
| -------------------------------- | ------ |
| Auto-numbering for inspo folders | ✅      |
| Notes folder creation            | ✅      |
| Core markdown files created      | ✅      |
| Obsidian-compatible image links  | ✅      |
| MidJourney Variations structure  | ✅      |
| Logging                          | ✅      |
| Dry run support                  | ✅      |
| CLI and callable as a module     | ✅      |


## 🔎 Version History
| Version | Date       | Notes                                                                                                    |
| ------- | ---------- | -------------------------------------------------------------------------------------------------------- |
| v1.0    | 2024-05-07 | First full release with self-instructive code, Obsidian link support, and Pinterest Scraper integration. |


## ⚠️ Disclaimer
This script is provided for personal and educational use. Use responsibly.
Always backup your vault before running automated scripts.

