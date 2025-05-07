"""
Pinterest Board Scraper v1.0 🖼️
Author: PtiCalin with the help of ChatGPT
Description: This script scrapes images from a Pinterest board and downloads them to a specified folder.
Usage: Set the BOARD_URL to the Pinterest board you want to scrape, and run the script.
Features: Auto-scrolls to load all pins, grabs unique image URLs, downloads them gently to avoid Pinterest wrath, and saves everything to your chosen folder.
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

# 📌 YOUR Pinterest board URL (replace this with your actual board URL)
BOARD_URL = 'YOUR_BOARD_URL_HERE'

# 📁 Folder where downloaded images will be saved
DOWNLOAD_FOLDER = 'pinterest_images'

# 🕒 How long to wait after each scroll (seconds)
SCROLL_PAUSE_TIME = 5  # Make it longer for big boards (e.g., 5-10 seconds)

# 🔄 Number of scrolls to perform to load images (adjust depending on board size)
MAX_SCROLLS = 50  # Go big for large boards

# 💤 Time to wait between downloading each image (seconds)
DOWNLOAD_PAUSE_TIME = 3  # Slow down requests to avoid Pinterest rate-limiting you

# --- SETUP SECTION ---

# Create folder if it doesn't exist
if not os.path.exists(DOWNLOAD_FOLDER):
    os.makedirs(DOWNLOAD_FOLDER)
    print(f"✅ Created folder: {DOWNLOAD_FOLDER}")
else:
    print(f"📂 Download folder exists: {DOWNLOAD_FOLDER}")

# Initialize Selenium WebDriver (automatically manages your Chrome driver version)
print("🚀 Launching Chrome browser...")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

# Open the Pinterest board
print(f"🌐 Opening Pinterest board: {BOARD_URL}")
driver.get(BOARD_URL)

# --- SCROLLING SECTION ---

print(f"🔽 Starting to scroll ({MAX_SCROLLS} times)...")

for scroll_number in range(1, MAX_SCROLLS + 1):
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    print(f"   ⏬ Scrolled {scroll_number}/{MAX_SCROLLS}")
    time.sleep(SCROLL_PAUSE_TIME)

print("✅ Finished scrolling. Collecting image URLs...")

# --- IMAGE COLLECTION SECTION ---

# Find all <img> tags
images = driver.find_elements(By.TAG_NAME, 'img')

# Extract unique image URLs that contain 'pinimg.com' (Pinterest's image CDN)
img_urls = set()
for img in images:
    src = img.get_attribute('src')
    if src and 'pinimg.com' in src:
        img_urls.add(src)

print(f"🔍 Found {len(img_urls)} images to download.")

# --- IMAGE DOWNLOAD SECTION ---

for idx, img_url in enumerate(img_urls):
    try:
        print(f"   📥 Downloading image {idx + 1}/{len(img_urls)}")
        img_data = requests.get(img_url).content
        image_filename = os.path.join(DOWNLOAD_FOLDER, f'image_{idx + 1}.jpg')

        with open(image_filename, 'wb') as handler:
            handler.write(img_data)

        time.sleep(DOWNLOAD_PAUSE_TIME)  # Pause to avoid getting blocked

    except Exception as e:
        print(f"⚠️ Failed to download {img_url}: {e}")

# --- CLEANUP SECTION ---

driver.quit()
print("🎉 All done! Your images are waiting in the folder:", DOWNLOAD_FOLDER)
