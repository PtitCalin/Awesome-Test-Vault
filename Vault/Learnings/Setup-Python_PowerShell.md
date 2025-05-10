---
id: quest-python-powershell-protocol
title: "🐍 Python Protocol — PowerShell (Windows 11)"
type: quest
version: 1.0
status: complete
created: 2025-05-08
updated: 2025-05-08
tags: [python, terminal, windows, powershell, installation, quest]
category: 🖥️ Terminal Skills
summary: >
  Learn how to verify, install, check, and update Python using PowerShell on Windows 11.
related: []
reward: 🧠 Terminal Wizardry +1
difficulty: 🟢 Easy
---

## 🧪 Python Protocol — PowerShell (Windows 11)
_Quest: Manage Python via Terminal_

### 🎯 Goal  
Verify, install, check version, and update Python using PowerShell.

---

### 1. ✅ Verify if Python is Installed

```powershell
python --version
```
or  
```powershell
python3 --version
```

✅ Success = You see something like:  
`Python 3.11.4`

🛑 If "command not found": Python is not installed or not on your PATH.

---

### 2. 📥 Install Python via Terminal (winget)

```powershell
winget install Python.Python.3
```

Note: Accept any prompts that appear. You may be asked to agree to terms.

---

### 3. 🔍 Check Python Version

```powershell
python --version
```
or
```powershell
py --version
```

📌 Tip: `py` is the Python launcher — often installed with Python.

---

### 4. ⬆️ Update Python to the Latest Version

```powershell
winget upgrade Python.Python.3
```

✅ Success = You see confirmation that Python is upgraded.

---

### 📎 Troubleshooting

- If `python` still doesn’t work after install, try restarting PowerShell or your computer.
- You can also try:
  ```powershell
  py
  ```

---

### 🧰 Extra: Check Where Python is Installed

```powershell
where python
```
