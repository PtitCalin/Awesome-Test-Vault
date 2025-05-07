---
Name: "Build Inspo Batch Folder Script (Bash)"
Description: "Create an automated Bash script to generate MidJourney inspo folders with subfolders and description files, supporting batch creation and dry-run mode."
Skill_Trees:
  - Programming & Scripting
  - Developer Fundamentals
Difficulty: "Medium"
Scope: "Medium"
Bonuses:
  - Documentation
  - Automation
Status: "Completed"
Date_Assigned: 2025-05-06
Date_Completed: 
Related_SN:
  - Bash Nugget
  - Automation Nugget
  - Documentation Nugget
Quest_Tags:
  - bash
  - function_creation
  - argument_parsing
  - dry_run_logic
  - documentation
  - error_handling
  - looping
  - testing
  - modular_design
Related_Lessons:
  - Bash scripting basics
  - Argument parsing techniques
  - Dry-run scripting patterns
Notes: >
  This quest established the core scripting structure for automating the MidJourney inspo folder workflow using Bash. Modular design and dry-run safety were prioritized.
---

## 📝 Step-by-Step Code Building Process

### Step 1️⃣ — Script Header and Usage  `#bash #documentation #planning`
- Write a multi-line comment block at the top describing:
    - Script purpose.
    - Usage examples.
    - Design notes (dry-run safety, extensibility, etc.).

```bash

# 🎨 MidJourney Inspo Batch Folder Builder - Bash Version
# USAGE:
#   ./mj-inspo-builder.sh --batch 5 --start 7
#   ./mj-inspo-builder.sh --batch 5 --start 7 --dry-run

```

### Step 2️⃣ — Configuration Variables `#bash #variable_setup #planning`

- Define `BASE_PATH` or `VAULT_PATH` to control where the folders will be created.
    
- Benefits: Easy to change destination without editing logic later.

```bash

BASE_PATH="./"

```


### Step 3️⃣ — Argument Parsing `#bash #argument_parsing #error_handling`

- Capture and validate user input:
    
    - `--batch`
        
    - `--start`
        
    - `--dry-run`
        
- Use `case` or positional parameter parsing.
    
- Validate missing or invalid arguments with clear errors.


```bash

if [[ -z "$BATCH" || -z "$START" ]]; then
  echo "❌ Missing required arguments."
  exit 1
fi

```


### Step 4️⃣ — Helper Function `#bash #function_creation #modular_design`

- Create a reusable function: `create_var_folder_and_file`.
    
- Function tasks:
    
    - Create a subfolder (`var1` to `var4`).
        
    - Create an empty description file.
        
    - Support dry-run preview.

```bash

create_var_folder_and_file() {
  local parent="$1"
  local var_name="$2"
  # Logic here
}
```


### Step 5️⃣ — Batch Loop Logic `#bash #looping #string_formatting`

- Loop through `batch` times starting at `start`.
    
- Format folder names: `inspo_0001`, `inspo_0002`, etc.
    
- Call the helper function to create subfolders and files.

```bash

for (( i=0; i<BATCH; i++ )); do
  # Loop body
done

```


### Step 6️⃣ — Dry-Run Mode `#bash #dry_run_logic #testing`

- If `--dry-run` is active:
    
    - Output what _would_ happen.
        
- Otherwise:
    
    - Create folders/files.
        

```bash

if $DRY_RUN; then
  echo "Dry-run active"
else
  mkdir ...
fi

```


### Step 7️⃣ — Completion Message `#bash #user_feedback #testing`

- Output success/failure message and summary at end of script.

```bash

if $DRY_RUN; then
  echo "✅ DRY-RUN complete."
else
  echo "✅ All folders created successfully."
fi

```


## ✅ Quest Progression Checklist

|Progress Step|Status|
|---|---|
|Script header with usage examples added|✅|
|Arguments parsed and validated|✅|
|Helper function created|✅|
|Loop handles batch creation correctly|✅|
|Dry-run mode implemented and tested|✅|
|Script tested live and verified to work|✅|

---

## 🏅 Reward — Skill Nuggets Granted

|Nugget Type|Icon|Earned SN|
|---|---|---|
|Bash Nugget|🖥️|4|
|Automation Nugget|⚙️|+3 Bonus|
|Documentation Nugget|📝|+2 Bonus|

**Total SN Earned:** 9 SN

---

## 🧠 Linked Lessons

- Bash scripting basics.
    
- Argument parsing techniques.
    
- File and folder creation.
    
- Function writing.
    
- Dry-run scripting.
    
- Documentation best practices.
    

