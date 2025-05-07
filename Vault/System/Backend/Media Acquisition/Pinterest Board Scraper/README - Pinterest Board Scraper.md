# Pinterest Board Scraper 🖼️

This script scrapes images from a Pinterest board and downloads them to a specified folder.  
It supports large boards, avoids duplicates with a smart resume feature, generates sanitized filenames using Pin titles/descriptions, grabs the highest resolution versions available, and can automatically choose an available browser (Chrome, Firefox, or Edge).

---

## 🚀 Features

- ✅ Smart scrolling to load all pins
- ✅ Extracts unique image URLs
- ✅ Dry run mode for safe testing
- ✅ Resume support (skips already downloaded images)
- ✅ Randomized human-like download delays
- ✅ Timestamped logging for each downloaded image
- ✅ Automatic retries for failed downloads
- ✅ Progress bar (tqdm)
- ✅ Intelligent filename generation from Pin titles/descriptions
- ✅ Sanitizes filenames to prevent OS errors
- ✅ Grabs highest resolution versions of images
- ✅ Browser auto-detection (Chrome ➔ Firefox ➔ Edge)
- ✅ Graceful fallback if a browser is not available

---

## 🔧 Requirements

- Python 3.7+
- Google Chrome, Firefox, or Edge installed
- The following Python libraries:

```bash
pip install requests selenium webdriver-manager tqdm
```

---

## 📝 Usage

1. Clone/download this repository.
2. Open pinterest_scraper.py.
3. Set the BOARD_URL variable to your Pinterest board URL.
4. Adjust other settings:
    - SCROLL_PAUSE_TIME
    - MAX_SCROLLS
    - DOWNLOAD_PAUSE_TIME_RANGE
    - DRY_RUN = True (for testing, set to False to actually download images)
    - BROWSER = 'auto' (or choose 'chrome', 'firefox', 'edge')
5. Run the script:
```bash
pinterest-board-scraper_v5.py
```
    Images will be saved in the pinterest_images folder. The script will log downloaded files in downloaded_images.log for resume support.

---

🔎 Browser Auto-Detection
If you set:

```python
BROWSER = 'auto'
```
The script will try to launch Chrome, then Firefox, then Edge, picking the first available browser automatically.



**Built by PtiCalin with the help of ChatGPT**