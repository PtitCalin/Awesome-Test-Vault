





---
Template section
# -NEW VERSION- Version X.X

```python


```

---
# -NEW VERSION- Version 0.2

```python


```

# Version 0.1

```python
#!/usr/bin/env python3

# -----------------------------------------------------------------------------------
# 🖼 Linked Pinterest Board Scraper v0.1
# by 
# -----------------------------------------------------------------------------------
# SCRIPT NAME:
#   pinterest-inspo-scraper.py
#
# PURPOSE:
#   Scrape images from a Pinterest board, save them to the Inspo image folder,
#   and automatically create organized inspo folders and note files
#   using the MidJourney Inspo Folder Builder.
#
# INTEGRATION:
#   Calls builder_inspo-from-pinterest.py after each image download to:
#   - Assign an inspo_nnnn folder.
#   - Create standard markdown note files.
#   - Add Obsidian-compatible links to the image.
#
# HOW TO USE:
#   1. Set BOARD_URL and other settings in the CONFIGURATION section.
#   2. Run: python pinterest-inspo-scraper.py
#
# -----------------------------------------------------------------------------------

# --- IMPORTS ---

from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.edge.service import Service as EdgeService

from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager

from selenium.webdriver.common.by import By
import time
import requests
import os
import random
from datetime import datetime
from tqdm import tqdm
import re

# --- IMPORT Folder Builder ---
from builder_inspo-from-pinterest import create_inspo_folder

# -----------------------------------------------------------------------------------
# === CONFIGURATION ===
# -----------------------------------------------------------------------------------

BOARD_URL = 'YOUR_BOARD_URL_HERE'  # 👈 Replace with your Pinterest board URL

SCROLL_PAUSE_TIME = 5
MAX_SCROLLS = 50
DOWNLOAD_PAUSE_TIME_RANGE = (2, 6)
DRY_RUN = True
MAX_RETRIES = 3

# Browser choice:
# 'chrome' | 'firefox' | 'edge' | 'auto'
BROWSER = 'auto'

# Where to save downloaded images:
IMAGE_FOLDER = r"C:\Users\charl\OneDrive\Projets\Awesome Test\System\Awesome-Test-Vault\VAULT\Files and Media\Images\Inspo"

# Log file:
LOG_FILE = r"C:\Users\charl\OneDrive\Projets\Awesome Test\System\Awesome-Test-Vault\VAULT\System\Backend\Logs\Inspo File Scrape and Organization Log\scraper_log.txt"

# -----------------------------------------------------------------------------------
# === UTILITIES ===
# -----------------------------------------------------------------------------------

def sanitize_filename(text):
    """Sanitize filenames for OS compatibility."""
    text = re.sub(r'[\\/*?:"<>|]', "", text)
    text = re.sub(r'\s+', '_', text.strip())
    return text[:100]

def launch_browser(browser_choice):
    """Launch browser based on user choice or auto-detect."""
    print(f"🧭 Browser selected: {browser_choice}")

    if browser_choice == 'chrome':
        try:
            print("🧠 Trying Chrome...")
            return webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
        except Exception as e:
            print(f"❌ Chrome failed: {e}")
            raise

    elif browser_choice == 'firefox':
        try:
            print("🧠 Trying Firefox...")
            return webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()))
        except Exception as e:
            print(f"❌ Firefox failed: {e}")
            raise

    elif browser_choice == 'edge':
        try:
            print("🧠 Trying Edge...")
            return webdriver.Edge(service=EdgeService(EdgeChromiumDriverManager().install()))
        except Exception as e:
            print(f"❌ Edge failed: {e}")
            raise

    elif browser_choice == 'auto':
        for attempt_browser in ['chrome', 'firefox', 'edge']:
            try:
                print(f"🔎 Auto-trying {attempt_browser.capitalize()}...")
                return launch_browser(attempt_browser)
            except Exception:
                print(f"❌ {attempt_browser.capitalize()} not available. Trying next...")
        print("💀 No supported browsers found.")
        exit(1)

    else:
        raise ValueError("Unsupported browser choice.")

# -----------------------------------------------------------------------------------
# === STARTUP SUMMARY ===
# -----------------------------------------------------------------------------------

print("📝 SCRIPT SETTINGS:")
print(f"   Pinterest board URL: {BOARD_URL}")
print(f"   Browser: {BROWSER}")
print(f"   Scroll pause: {SCROLL_PAUSE_TIME}s | Max scrolls: {MAX_SCROLLS}")
print(f"   Download pause range: {DOWNLOAD_PAUSE_TIME_RANGE}s")
print(f"   Max retries: {MAX_RETRIES}")
print(f"   DRY RUN: {'ON' if DRY_RUN else 'OFF'}")
print("-" * 50)

# -----------------------------------------------------------------------------------
# === PREVIOUS DOWNLOAD CHECK ===
# -----------------------------------------------------------------------------------

if os.path.exists(LOG_FILE):
    with open(LOG_FILE, 'r') as f:
        downloaded = set(line.strip().split(',')[0] for line in f if line.strip())
    print(f"🔎 {len(downloaded)} images found in existing log.")
else:
    downloaded = set()
    print("🔎 No previous log found. Starting fresh.")

# -----------------------------------------------------------------------------------
# === BROWSER LAUNCH ===
# -----------------------------------------------------------------------------------

print("🚀 Launching browser...")
driver = launch_browser(BROWSER)
driver.get(BOARD_URL)

# -----------------------------------------------------------------------------------
# === SCROLLING ===
# -----------------------------------------------------------------------------------

print(f"🔽 Scrolling {MAX_SCROLLS} times...")

for scroll in range(1, MAX_SCROLLS + 1):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    print(f"   ⏬ Scroll {scroll}/{MAX_SCROLLS}")
    time.sleep(SCROLL_PAUSE_TIME)

print("✅ Scrolling complete. Gathering images...")

# -----------------------------------------------------------------------------------
# === COLLECT IMAGES & TITLES ===
# -----------------------------------------------------------------------------------

images = driver.find_elements(By.TAG_NAME, 'img')
img_data = []

for img in images:
    src = img.get_attribute('src')
    alt = img.get_attribute('alt') or img.get_attribute('aria-label') or "Pinterest_Image"

    if src and 'pinimg.com' in src:
        hi_res_src = re.sub(r'/\d+x/', '/originals/', src)
        img_data.append((hi_res_src, alt))

print(f"🔍 Found {len(img_data)} potential images.")
print("-" * 50)

# -----------------------------------------------------------------------------------
# === DOWNLOAD & ORGANIZE IMAGES ===
# -----------------------------------------------------------------------------------

new_downloads = 0
log_file = open(LOG_FILE, 'a') if not DRY_RUN else None

for idx, (img_url, title) in enumerate(tqdm(img_data, desc="Processing images", unit="image")):

    if img_url in downloaded:
        tqdm.write(f"   🔁 Skipping already downloaded image {idx + 1}")
        continue

    filename = sanitize_filename(title) or f"image_{idx + 1}"
    image_filename = f"{filename}.jpg"
    full_image_path = os.path.join(IMAGE_FOLDER, image_filename)

    if DRY_RUN:
        tqdm.write(f"[DRY RUN] Would download image: {image_filename}")
    else:
        attempt = 0
        success = False

        while attempt < MAX_RETRIES and not success:
            try:
                tqdm.write(f"📥 Downloading {filename} (attempt {attempt + 1})")
                response = requests.get(img_url, timeout=15)
                img_data_bytes = response.content

                os.makedirs(IMAGE_FOLDER, exist_ok=True)

                with open(full_image_path, 'wb') as f:
                    f.write(img_data_bytes)

                success = True

            except Exception as e:
                tqdm.write(f"⚠️ Failed attempt {attempt + 1} for {img_url}: {e}")
                attempt += 1

        if not success:
            tqdm.write(f"❌ Skipped after {MAX_RETRIES} failed attempts.")
            continue

        # --- CALL THE FOLDER BUILDER ---
        tqdm.write(f"🔧 Creating inspo folder and linking image...")
        inspo_folder = create_inspo_folder(
            image_filename=image_filename,
            title=title,
            pinterest_url=img_url,
            dry_run=DRY_RUN
        )

        # --- LOG THIS DOWNLOAD ---
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{img_url},{image_filename},{inspo_folder},{timestamp}\n"

        if DRY_RUN:
            tqdm.write(f"[DRY RUN] Would log: {log_entry}")
        else:
            log_file.write(log_entry)
            log_file.flush()

        new_downloads += 1

        pause = random.uniform(*DOWNLOAD_PAUSE_TIME_RANGE)
        tqdm.write(f"   ⏳ Waiting {pause:.2f}s before next download...")
        time.sleep(pause)

if log_file:
    log_file.close()

driver.quit()

print("-" * 50)
if DRY_RUN:
    print("✅ DRY RUN complete. No images downloaded or folders created.")
else:
    print(f"🎉 Downloaded and organized {new_downloads} new images into inspo folders.")

# -----------------------------------------------------------------------------------
# === END OF SCRIPT ===
# -----------------------------------------------------------------------------------

```