# BenFolderWatcher.py
pip install watchdog pystray pillow


import os
import time
import threading
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import pystray
from pystray import MenuItem as item
from PIL import Image, ImageDraw
import datetime

######################################
# CONFIGURATION
######################################

WATCHED_FOLDER = r"C:\Users\benny\Dropbox\Family Room\À FAIRE\02-À Jouer\BEN"
LOG_FILE = os.path.join(WATCHED_FOLDER, "BenFolderWatcher_Log.txt")
DRY_RUN = True

######################################
# LOGGING FUNCTION
######################################

def log(message):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"[{timestamp}] {message}\n"
    print(entry.strip())
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(entry)

######################################
# FOLDER EVENT HANDLER
######################################

class FolderEventHandler(FileSystemEventHandler):
    def on_created(self, event):
        if event.is_directory:
            folder_name = os.path.basename(event.src_path)
            subfolder_name = f"{folder_name} (animation)"
            subfolder_path = os.path.join(event.src_path, subfolder_name)

            if not os.path.exists(subfolder_path):
                if DRY_RUN:
                    log(f"[DRY RUN] Would create subfolder: {subfolder_path}")
                else:
                    try:
                        os.mkdir(subfolder_path)
                        log(f"Created subfolder: {subfolder_path}")
                    except Exception as e:
                        log(f"ERROR creating subfolder: {e}")
            else:
                log(f"Subfolder already exists: {subfolder_path}")

######################################
# WATCHER STARTUP
######################################

def start_watching():
    if not os.path.exists(WATCHED_FOLDER):
        log("ERROR: Watched folder does not exist.")
        return

    event_handler = FolderEventHandler()
    observer = Observer()
    observer.schedule(event_handler, WATCHED_FOLDER, recursive=False)
    observer.start()
    log("Started watching for new folders...")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

######################################
# TRAY ICON SETUP
######################################

def create_image():
    # Create a simple tray icon (circle with a play symbol)
    image = Image.new('RGB', (64, 64), color=(200, 200, 200))
    d = ImageDraw.Draw(image)
    d.ellipse((8, 8, 56, 56), fill=(100, 150, 255))
    d.polygon([(24, 20), (44, 32), (24, 44)], fill=(255, 255, 255))
    return image

def on_toggle_dryrun(icon, item):
    global DRY_RUN
    DRY_RUN = not DRY_RUN
    status = "ON" if DRY_RUN else "OFF"
    log(f"Dry Run mode toggled to: {status}")

def on_quit(icon, item):
    log("Ben’s Folder Watcher exited by user.")
    icon.stop()

def run_tray():
    icon = pystray.Icon(
        "BenFolderWatcher",
        create_image(),
        "Ben's Folder Watcher 🐻✨",
        menu=pystray.Menu(
            item(
                lambda text="Dry Run Mode", state=lambda item: DRY_RUN,
                action=on_toggle_dryrun
            ),
            item("Quit", on_quit)
        )
    )
    icon.run()

######################################
# MAIN STARTUP
######################################

if __name__ == "__main__":
    # Start the folder watcher in a separate thread
    watcher_thread = threading.Thread(target=start_watching, daemon=True)
    watcher_thread.start()

    # Start the tray icon
    run_tray()
