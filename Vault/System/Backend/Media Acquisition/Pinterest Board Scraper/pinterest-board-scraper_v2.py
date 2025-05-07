"""
Pinterest Board Scraper v2.0 🖼️
Author: PtiCalin with the help of ChatGPT
Description: This script scrapes images from a Pinterest board and downloads them to a specified folder.
Usage: Set the BOARD_URL to the Pinterest board you want to scrape, and run the script.
Features: Scrolls to load pins, extracts unique image URLs, offers dry run testing mode, downloads images gently to avoid rate limits, and narrates every action with clear echoes.
"""

# --- IMPORTS ---
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import time
import requests
import os

# --- CONFIGURATION SECTION ---

# 📌 YOUR Pinterest board URL
BOARD_URL = 'YOUR_BOARD_URL_HERE'

# 📁 Folder for downloaded images
DOWNLOAD_FOLDER = 'pinterest_images'

# 🕒 Timing settings
SCROLL_PAUSE_TIME = 5    # Seconds to wait between scrolls
MAX_SCROLLS = 50         # Number of scrolls
DOWNLOAD_PAUSE_TIME = 3  # Seconds to wait between image downloads

# 🧪 DRY RUN MODE (True = test only, no downloads will happen)
DRY_RUN = True

# --- STARTUP SUMMARY ---

print("📝 SCRIPT SETTINGS:")
print(f"   Pinterest board URL: {BOARD_URL}")
print(f"   Download folder: {DOWNLOAD_FOLDER}")
print(f"   Scroll pause time: {SCROLL_PAUSE_TIME} seconds")
print(f"   Max scrolls: {MAX_SCROLLS}")
print(f"   Download pause time: {DOWNLOAD_PAUSE_TIME} seconds")
print(f"   DRY RUN mode: {'ON (no images will be downloaded)' if DRY_RUN else 'OFF (images WILL be downloaded!)'}")
print("-" * 50)

# --- SETUP ---

# Create folder if needed
if not os.path.exists(DOWNLOAD_FOLDER):
    print(f"📂 Folder '{DOWNLOAD_FOLDER}' does not exist. Creating it...")
    if not DRY_RUN:
        os.makedirs(DOWNLOAD_FOLDER)
else:
    print(f"📂 Folder exists: {DOWNLOAD_FOLDER}")

# Launch browser
print("🚀 Launching Chrome browser...")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

# Open board
print(f"🌐 Opening Pinterest board: {BOARD_URL}")
driver.get(BOARD_URL)

# --- SCROLLING ---

print(f"🔽 Scrolling {MAX_SCROLLS} times to load images...")

for scroll_number in range(1, MAX_SCROLLS + 1):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    print(f"   ⏬ Scroll {scroll_number}/{MAX_SCROLLS} complete.")
    time.sleep(SCROLL_PAUSE_TIME)

print("✅ Finished scrolling. Collecting image URLs...")

# --- COLLECTING IMAGES ---

images = driver.find_elements(By.TAG_NAME, 'img')
img_urls = set()

for img in images:
    src = img.get_attribute('src')
    if src and 'pinimg.com' in src:
        img_urls.add(src)

print(f"🔍 Found {len(img_urls)} image URLs.")
print("-" * 50)

# --- DOWNLOADING IMAGES ---

if DRY_RUN:
    print("🚧 DRY RUN MODE: No images will be downloaded. Showing planned actions...")
else:
    print("📥 Starting image downloads...")

for idx, img_url in enumerate(img_urls):
    image_filename = os.path.join(DOWNLOAD_FOLDER, f'image_{idx + 1}.jpg')

    if DRY_RUN:
        print(f"[DRY RUN] Would download image {idx + 1}/{len(img_urls)} -> {image_filename}")
    else:
        try:
            print(f"📥 Downloading image {idx + 1}/{len(img_urls)}")
            img_data = requests.get(img_url).content
            with open(image_filename, 'wb') as handler:
                handler.write(img_data)
            time.sleep(DOWNLOAD_PAUSE_TIME)
        except Exception as e:
            print(f"⚠️ Failed to download {img_url}: {e}")

# --- CLEANUP ---

print("-" * 50)
driver.quit()

if DRY_RUN:
    print("✅ DRY RUN complete. No images were downloaded.")
else:
    print("🎉 All done! Images downloaded to folder:", DOWNLOAD_FOLDER)
