---
id: quest-selenium-webdrivers
title: "🕷️ Selenium Setup — Firefox & Edge WebDrivers (Windows 11)"
type: quest
version: 1.0
status: complete
created: 2025-05-08
updated: 2025-05-08
tags: [selenium, automation, python, webdriver, firefox, edge, terminal]
category: 🖥️ Terminal Skills
summary: >
  Learn how to install Selenium, set up GeckoDriver (Firefox) and EdgeDriver (Edge), and verify functionality on Windows 11 using PowerShell.
related: []
reward: ⚙️ Automation Adept +1
difficulty: 🟡 Intermediate
---

## 🕷️ Selenium Setup — Firefox & Edge WebDrivers (Windows 11)
_Quest: Install Selenium and configure webdrivers for browser automation_

---

### 1. 🔧 Install Selenium with pip

```powershell
pip install selenium
```
Or with Python launcher:
```powershell
py -m pip install selenium
```

✅ You can now import `selenium` in Python scripts.

---

### 2. 🦊 Set up Firefox WebDriver (GeckoDriver)

**A. Download GeckoDriver**  
Go to → https://github.com/mozilla/geckodriver/releases  
Download the **latest Windows 64-bit** `.zip`.

**B. Extract `geckodriver.exe` to:**
```
C:\WebDrivers\geckodriver.exe
```

**C. Add `C:\WebDrivers` to your PATH:**
1. Open *System Properties* → Environment Variables.
2. Edit **Path** in *System Variables*.
3. Add `C:\WebDrivers`.

**D. Test it:**
```powershell
geckodriver --version
```

---

### 3. 🧭 Set up Edge WebDriver (EdgeDriver)

**A. Find your Edge version:**
```powershell
msedge --version
```

**B. Download EdgeDriver for your version:**  
Go to → https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/

**C. Extract `msedgedriver.exe` to:**
```
C:\WebDrivers\msedgedriver.exe
```

**D. Ensure folder is in your PATH.**

**E. Test it:**
```powershell
msedgedriver --version
```

---

### 4. ✅ Run a Quick Selenium Test

**Test with Firefox:**
```python
from selenium import webdriver

driver = webdriver.Firefox()
driver.get("https://www.google.com")
```

**Test with Edge:**
```python
from selenium import webdriver
from selenium.webdriver.edge.service import Service

driver = webdriver.Edge()
driver.get("https://www.google.com")
```

---

🎉 Quest Complete — You are ready to automate the web!
