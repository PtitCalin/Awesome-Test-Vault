"""
Pinterest Board Scraper v5.0 🖼️
Author: PtiCalin with the help of ChatGPT
Description: Scrapes images from a Pinterest board using any available browser. Names files by Pin titles/descriptions, downloads highest-res versions, and logs everything.
Features: Smart scrolling, Dry run, Resume support, Random delays, Timestamped logs, Retry failed downloads, Progress bar, Parse titles/descriptions, Sanitize filenames, High-res grabbing, Browser auto-detection, Graceful fallback
"""

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

# --- CONFIGURATION ---

BOARD_URL = 'YOUR_BOARD_URL_HERE'
DOWNLOAD_FOLDER = 'pinterest_images'
SCROLL_PAUSE_TIME = 5
MAX_SCROLLS = 50
DOWNLOAD_PAUSE_TIME_RANGE = (2, 6)
DRY_RUN = True
MAX_RETRIES = 3

# Browser choice:
# 'chrome' | 'firefox' | 'edge' | 'auto' (auto-tries Chrome ➔ Firefox ➔ Edge)
BROWSER = 'auto'

LOG_FILE = os.path.join(DOWNLOAD_FOLDER, 'downloaded_images.log')

# --- UTILITIES ---

def sanitize_filename(text):
    """Sanitize filenames to avoid OS errors."""
    text = re.sub(r'[\\/*?:"<>|]', "", text)
    text = re.sub(r'\s+', '_', text.strip())
    return text[:100]

def launch_browser(browser_choice):
    """Launches the browser or auto-detects."""
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
        print("💀 No supported browsers found. Please install Chrome, Firefox, or Edge.")
        exit(1)

    else:
        raise ValueError("Unsupported browser. Choose 'chrome', 'firefox', 'edge', or 'auto'.")

# --- STARTUP SUMMARY ---

print("📝 SCRIPT SETTINGS:")
print(f"   Pinterest board URL: {BOARD_URL}")
print(f"   Download folder: {DOWNLOAD_FOLDER}")
print(f"   Browser: {BROWSER}")
print(f"   Scroll pause: {SCROLL_PAUSE_TIME}s | Max scrolls: {MAX_SCROLLS}")
print(f"   Download pause range: {DOWNLOAD_PAUSE_TIME_RANGE}s")
print(f"   Max retries: {MAX_RETRIES}")
print(f"   DRY RUN: {'ON' if DRY_RUN else 'OFF'}")
print("-" * 50)

# --- SETUP ---

if not os.path.exists(DOWNLOAD_FOLDER):
    print(f"📂 Creating folder '{DOWNLOAD_FOLDER}'...")
    if not DRY_RUN:
        os.makedirs(DOWNLOAD_FOLDER)
else:
    print(f"📂 Folder exists: {DOWNLOAD_FOLDER}")

if os.path.exists(LOG_FILE):
    with open(LOG_FILE, 'r') as f:
        downloaded = set(line.strip().split(',')[0] for line in f if line.strip())
    print(f"🔎 {len(downloaded)} images found in existing log.")
else:
    downloaded = set()
    print("🔎 No log found. Starting fresh.")

# --- BROWSER LAUNCH ---

print("🚀 Launching browser...")
driver = launch_browser(BROWSER)
driver.get(BOARD_URL)

# --- SCROLLING ---

print(f"🔽 Scrolling {MAX_SCROLLS} times...")

for scroll in range(1, MAX_SCROLLS + 1):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    print(f"   ⏬ Scroll {scroll}/{MAX_SCROLLS}")
    time.sleep(SCROLL_PAUSE_TIME)

print("✅ Scrolling complete. Gathering images...")

# --- COLLECT IMAGES & TITLES ---

images = driver.find_elements(By.TAG_NAME, 'img')
img_data = []

for img in images:
    src = img.get_attribute('src')
    alt = img.get_attribute('alt') or img.get_attribute('aria-label') or "Pinterest_Image"

    if src and 'pinimg.com' in src:
        hi_res_src = re.sub(r'/\d+x/', '/originals/', src)
        img_data.append((hi_res_src, sanitize_filename(alt)))

print(f"🔍 Found {len(img_data)} potential images.")
print("-" * 50)

# --- DOWNLOAD IMAGES ---

if DRY_RUN:
    print("🚧 DRY RUN: No images will be downloaded. Listing planned actions...")
else:
    print("📥 Starting downloads...")

new_downloads = 0
log_file = open(LOG_FILE, 'a') if not DRY_RUN else None

for idx, (img_url, title) in enumerate(tqdm(img_data, desc="Downloading", unit="image")):

    if img_url in downloaded:
        tqdm.write(f"   🔁 Skipping already downloaded image {idx + 1}")
        continue

    filename = sanitize_filename(title) or f"image_{idx + 1}"
    image_filename = os.path.join(DOWNLOAD_FOLDER, f"{filename}.jpg")

    if DRY_RUN:
        tqdm.write(f"[DRY RUN] Would download: {image_filename}")
    else:
        attempt = 0
        success = False

        while attempt < MAX_RETRIES and not success:
            try:
                tqdm.write(f"📥 Downloading {filename} (attempt {attempt + 1})")
                response = requests.get(img_url, timeout=15)
                img_data_bytes = response.content

                with open(image_filename, 'wb') as f:
                    f.write(img_data_bytes)

                timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                log_file.write(f"{img_url},{image_filename},{timestamp}\n")
                log_file.flush()

                new_downloads += 1
                success = True

                pause = random.uniform(*DOWNLOAD_PAUSE_TIME_RANGE)
                tqdm.write(f"   ⏳ Waiting {pause:.2f}s before next download...")
                time.sleep(pause)

            except Exception as e:
                tqdm.write(f"⚠️ Failed attempt {attempt + 1} for {img_url}: {e}")
                attempt += 1

        if not success:
            tqdm.write(f"❌ Skipped after {MAX_RETRIES} failed attempts.")

if log_file:
    log_file.close()

driver.quit()

print("-" * 50)
if DRY_RUN:
    print("✅ DRY RUN complete. No images downloaded.")
else:
    print(f"🎉 Downloaded {new_downloads} new images to {DOWNLOAD_FOLDER}.")
