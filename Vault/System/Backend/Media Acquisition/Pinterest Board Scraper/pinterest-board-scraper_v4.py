"""
Pinterest Board Scraper v4.0 🖼️
Author: PtiCalin with the help of ChatGPT
Description: This script scrapes images from a Pinterest board and downloads them to a specified folder.
Usage: Set the BOARD_URL to the Pinterest board you want to scrape, and run the script.
Features: Dry run, resume support, randomized delays, timestamped logging, and detailed echoes!
"""

# --- IMPORTS ---
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import time
import requests
import os
import random
from datetime import datetime

# --- CONFIGURATION SECTION ---

BOARD_URL = 'YOUR_BOARD_URL_HERE'
DOWNLOAD_FOLDER = 'pinterest_images'
SCROLL_PAUSE_TIME = 5
MAX_SCROLLS = 50
DOWNLOAD_PAUSE_TIME_RANGE = (2, 6)  # Random delay between downloads (min, max seconds)
DRY_RUN = True

LOG_FILE = os.path.join(DOWNLOAD_FOLDER, 'downloaded_images.log')

# --- STARTUP SUMMARY ---

print("📝 SCRIPT SETTINGS:")
print(f"   Pinterest board URL: {BOARD_URL}")
print(f"   Download folder: {DOWNLOAD_FOLDER}")
print(f"   Scroll pause time: {SCROLL_PAUSE_TIME} seconds")
print(f"   Max scrolls: {MAX_SCROLLS}")
print(f"   Download pause time range: {DOWNLOAD_PAUSE_TIME_RANGE} seconds")
print(f"   DRY RUN mode: {'ON (no images will be downloaded)' if DRY_RUN else 'OFF (images WILL be downloaded!)'}")
print("-" * 50)

# --- SETUP ---

if not os.path.exists(DOWNLOAD_FOLDER):
    print(f"📂 Folder '{DOWNLOAD_FOLDER}' does not exist. Creating it...")
    if not DRY_RUN:
        os.makedirs(DOWNLOAD_FOLDER)
else:
    print(f"📂 Download folder exists: {DOWNLOAD_FOLDER}")

if os.path.exists(LOG_FILE):
    with open(LOG_FILE, 'r') as f:
        downloaded = set(line.strip().split(',')[0] for line in f if line.strip())
    print(f"🔎 Found {len(downloaded)} previously downloaded images in log.")
else:
    downloaded = set()
    print("🔎 No previous download log found. Starting fresh.")

print("🚀 Launching Chrome browser...")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
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

print(f"🔍 Found {len(img_urls)} unique image URLs.")
print("-" * 50)

# --- DOWNLOADING IMAGES ---

if DRY_RUN:
    print("🚧 DRY RUN MODE: No images will be downloaded. Showing planned actions...")
else:
    print("📥 Starting image downloads...")

new_downloads = 0
log_file = open(LOG_FILE, 'a') if not DRY_RUN else None

for idx, img_url in enumerate(img_urls):

    if img_url in downloaded:
        print(f"   🔁 Skipping already downloaded image {idx + 1}/{len(img_urls)}")
        continue

    image_filename = os.path.join(DOWNLOAD_FOLDER, f'image_{idx + 1}.jpg')

    if DRY_RUN:
        print(f"[DRY RUN] Would download image {idx + 1}/{len(img_urls)} -> {image_filename}")
    else:
        try:
            print(f"📥 Downloading image {idx + 1}/{len(img_urls)}")
            img_data = requests.get(img_url).content
            with open(image_filename, 'wb') as handler:
                handler.write(img_data)

            # Timestamp for logging
            timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            log_file.write(f"{img_url},{image_filename},{timestamp}\n")
            log_file.flush()

            new_downloads += 1

            # Random pause
            pause_duration = random.uniform(*DOWNLOAD_PAUSE_TIME_RANGE)
            print(f"   ⏳ Waiting {pause_duration:.2f} seconds before next download...")
            time.sleep(pause_duration)

        except Exception as e:
            print(f"⚠️ Failed to download {img_url}: {e}")

if log_file:
    log_file.close()

driver.quit()

print("-" * 50)
if DRY_RUN:
    print("✅ DRY RUN complete. No images were downloaded.")
else:
    print(f"🎉 Download complete! {new_downloads} new images saved to {DOWNLOAD_FOLDER}.")

