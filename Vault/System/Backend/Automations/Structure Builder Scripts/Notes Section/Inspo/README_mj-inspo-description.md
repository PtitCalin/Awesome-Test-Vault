
# 🎨 MidJourney Inspo Batch Folder Builder

**Author:** Charlie Bouchard  
**Purpose:** Automate the creation of structured folders for MidJourney image description and artistic reflection workflows.

---

## 📝 General Purpose

This script family automates the batch creation of **"inspo" folders** used for structured image reflection.

Each "inspo" folder contains **4 variant subfolders** (`var1` to `var4`), each with an empty description file where you can document:

- Manual image observations.
- MidJourney-generated descriptions.
- Vocabulary-building reflections.

### 🗂 Folder Structure Example

```
inspo_0001/
  var1/
    var1_description.txt
  var2/
    var2_description.txt
  var3/
    var3_description.txt
  var4/
    var4_description.txt
```

---

## 🔧 Design Philosophy

- **Cross-platform**: Scripts provided in Bash, PowerShell, Python, Ruby, and Node.js.
- **Educational**: Each script follows a clear, instructive style with detailed comments and usage examples.
- **Dry-run Support**: Preview the actions before creating any folders or files.
- **Batch Creation**: Automatically generate multiple inspo folders starting from any number.
- **Scalable**: Future-ready for CSV logging, YAML metadata, or Obsidian integrations.

---

## 🚀 Script Versions

### 1️⃣ Bash Version

**File:** `mj-inspo-builder.sh`

```bash
./mj-inspo-builder.sh --batch 5 --start 7
./mj-inspo-builder.sh --batch 5 --start 7 --dry-run
```

**Features:**
- Native for Linux/macOS.
- Uses `mkdir -p` and `touch`.
- Dry-run mode for previewing.

---

### 2️⃣ PowerShell Version

**File:** `mj-inspo-builder.ps1`

```powershell
.\mj-inspo-builder.ps1 -Batch 5 -Start 7
.\mj-inspo-builder.ps1 -Batch 5 -Start 7 -DryRun
```

**Features:**
- Windows-native scripting.
- Uses `New-Item`.
- Dry-run mode.
- Color-coded output.

---

### 3️⃣ Python Version

**File:** `mj_inspo_builder.py`

```bash
python mj_inspo_builder.py --batch 5 --start 7
python mj_inspo_builder.py --batch 5 --start 7 --dry-run
```

**Features:**
- Cross-platform.
- Uses `os.makedirs` and standard file handling.
- Dry-run mode.
- Highly extensible (CSV logging, YAML metadata, API integration ready).

---

### 4️⃣ Ruby Version

**File:** `mj_inspo_builder.rb`

```bash
ruby mj_inspo_builder.rb --batch 5 --start 7
ruby mj_inspo_builder.rb --batch 5 --start 7 --dry-run
```

**Features:**
- Cross-platform.
- Uses `FileUtils.mkdir_p` and `FileUtils.touch`.
- Dry-run mode.
- Concise, elegant scripting syntax.

---

### 5️⃣ Node.js Version

**File:** `mj-inspo-builder.js`

```bash
node mj-inspo-builder.js --batch 5 --start 7
node mj-inspo-builder.js --batch 5 --start 7 --dry-run
```

**Features:**
- Cross-platform (Node.js runtime required).
- Uses `fs.mkdirSync` and `fs.writeFileSync` for folder/file creation.
- Dry-run mode for safe previewing.
- Syntax similar to Bash and Python for easy transition.

---

## 🌟 Future Enhancements (Planned)

- 📊 CSV logging of created folders and files.
- 📄 Auto-generation of Obsidian Dataview YAML metadata.
- 📝 Logging summary after script execution.
- 🔗 Optional integration with the MidJourney API.

---

## 📚 Educational Purpose

This collection demonstrates how similar filesystem automation tasks can be implemented across **multiple scripting and programming languages**.

It’s designed to help compare **Bash, PowerShell, Python, Ruby, and Node.js** in a practical, creative context.

**Learning Outcomes:**
- Understand folder and file automation across different environments.
- Practice argument parsing, dry-run logic, and file system safety checks.
- Build reusable, scalable, and well-documented scripts.

---

## ⚠ Disclaimer

These scripts are provided for educational and creative purposes only.  
Use at your own risk. Always back up your data before running scripts that modify your filesystem.

---

✨ *Happy creating and reflecting!*
