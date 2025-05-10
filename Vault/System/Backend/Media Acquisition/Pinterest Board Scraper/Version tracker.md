





---
Template section
# -NEW VERSION- Version X.X

```python


```

---


# Version 0.5

Modular & Browser-Aware Script

🧱 Feature-rich and modularized:
- Fully abstracted browser logic with auto-detection for Chrome, Firefox, Edge.
- Added high-resolution grabbing and filename sanitization.
- Modular logging and smart resume.
- Structured scroll + download config options.
- Smart fallback when browser options fail.

At this stage, the scraper graduated into a *real tool* — modular, portable, and extendable.

```python
"""
Pinterest Board Scraper v0.5 🖼️
Author: PtiCalin
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


```


# Version 0.4

💪 Stronger and more resilient

- Added **automatic retry logic** for failed downloads.
- Introduced **progress bars** with tqdm for visual feedback.
- Kept dry-run, resume, logging, and echo improvements from earlier versions.

This version felt like an actual assistant — smart, clear, persistent, and interactive.

```python
"""
Pinterest Board Scraper v0.4 🖼️
Author: PtiCalin
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


```


# Version 0.3

Major UX improvements and smarter behavior

- Introduced a **resume feature** using a local log file.
- Skips images already downloaded in past sessions.
- Improved narration throughout for each action.

```python
"""
Pinterest Board Scraper v0.3 🖼️
Author: PtiCalin
Description: This script scrapes images from a Pinterest board and downloads them to a specified folder.
Usage: Set the BOARD_URL to the Pinterest board you want to scrape, and run the script.
Features: Scrolls and grabs unique image URLs, dry run ready, remembers past downloads with a smart log to avoid duplicates, and narrates every step like a courteous robot butler.
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

BOARD_URL = 'YOUR_BOARD_URL_HERE'
DOWNLOAD_FOLDER = 'pinterest_images'
SCROLL_PAUSE_TIME = 5
MAX_SCROLLS = 50
DOWNLOAD_PAUSE_TIME = 3
DRY_RUN = True  # Set to False to actually download

# LOG FILE where we keep track of downloaded images
LOG_FILE = os.path.join(DOWNLOAD_FOLDER, 'downloaded_images.log')

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
    print(f"📂 Download folder exists: {DOWNLOAD_FOLDER}")

# Load previously downloaded image URLs
if os.path.exists(LOG_FILE):
    with open(LOG_FILE, 'r') as f:
        downloaded = set(line.strip().split(',')[0] for line in f if line.strip())
    print(f"🔎 Found {len(downloaded)} previously downloaded images in log.")
else:
    downloaded = set()
    print("🔎 No previous download log found. Starting fresh.")

# Launch browser
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

# Open log file in append mode (only if not a dry run)
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

            # Log the download
            log_file.write(f"{img_url},{image_filename}\n")
            log_file.flush()

            new_downloads += 1
            time.sleep(DOWNLOAD_PAUSE_TIME)

        except Exception as e:
            print(f"⚠️ Failed to download {img_url}: {e}")

# Close the log file
if log_file:
    log_file.close()

driver.quit()

print("-" * 50)
if DRY_RUN:
    print("✅ DRY RUN complete. No images were downloaded.")
else:
    print(f"🎉 Download complete! {new_downloads} new images saved to {DOWNLOAD_FOLDER}.")


```

# Version 0.2

Introduced key safety and usability improvements

- Added **dry run mode** to test without downloading.
- Added clear script summaries for clarity.
- Modularized scroll + download timeouts.
- More informative echoes throughout.

```python
"""
Pinterest Board Scraper v0.2 🖼️
Author: PtiCalin
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


```

# Version 0.1

🚧 First working draft of the scraper. 

Introduced core scraping logic with:
- Basic Selenium-powered scrolling.
- Extraction of <img> tags containing Pinterest CDN content.
- Simple download loop with adjustable scroll + pause parameters.

```python
"""
Pinterest Board Scraper v0.1 🖼️
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

```







