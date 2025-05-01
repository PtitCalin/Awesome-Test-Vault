# 📚 Learning Structure Builder

---

## 🛠️ About This Script

This script initializes the **Learning** section of your Obsidian Vault for the Awesome Test Vault project by generating its base structure. 

---

### ✅ What It Builds

- 📂 A top-level `/Learnings` folder
- 🗂️ Learning modules by theme (e.g., GitHub, Terminal, Python)
- 📋 Dashboards for each section
- 🧩 Quests with XP, skills gained, requirements, and YAML tracking
- 🧠 Core learning tools (Curriculum, Skill Tree, Progress Tracker)

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


## 🗺️ Structure Generated
```bash
Learnings/
├── 00 Learning Management/
│   ├── 00 Learning Management.md
│   ├── Progress Tracker.md
│   ├── Skill Tree.md
│   ├── Curriculum Overview.md
│   ├── Quest Log.md
│   └── Dashboards.md
├── 01 Setup/
│   ├── Dashboard + Lessons + Quests/
├── 02 GitHub/
│   ├── Dashboard + Lessons + Quests/
├── 03 Terminal & File Navigation/
│   ├── Dashboard + Lessons + Quests/
├── 04 Git/
│   ├── Dashboard + Lessons + Quests/
├── 05 Python/
│   ├── Dashboard + Lessons + Quests/
├── 06 APIs/
│   ├── Dashboard + Lessons + Quests/
├── 07 Data Formats (YAML, JSON, RSS)/
│   ├── Dashboard + Lessons + Quests/
├── 08 SQL and Databases/
│   ├── Dashboard + Lessons + Quests/
```
Each section includes:

✅ A dashboard .md acting as a hub for linked child notes

✅ Lesson files (01 - Lesson Title.md)

✅ A Quests/ folder with fully pre-filled quest templates

### 🛠️ How to Extend

Want to add new sections later?
Open the script and follow this pattern:

```bash
# === New Section
NEWSECTION_ROOT="$LEARNING_ROOT/09 New Section"
echo "📦 Creating 09 New Section..."
create_dashboard "$NEWSECTION_ROOT" "09 New Section"
create_file "$NEWSECTION_ROOT" "01 - New Lesson"
create_quest "$NEWSECTION_ROOT/Quests" "Quest 1 - New Quest Title" "09 New Section"
```
Then re-run the script to generate it.

### 💡 Suggested Uses

✅ Track your learning journey across technical tools, workflows, and concepts

✅ Log quests with difficulty, XP earned, and dependencies

✅ Build a curriculum over time with branching paths and a skill tree

✅ Integrate quests into your Daily Notes, Projects, or Vault Missions

### ✨ Credits
Script created as part of the [Awesome Test Vault Project]
Structure and framework by PtiCalin 💛
Supported by ChatGPT

