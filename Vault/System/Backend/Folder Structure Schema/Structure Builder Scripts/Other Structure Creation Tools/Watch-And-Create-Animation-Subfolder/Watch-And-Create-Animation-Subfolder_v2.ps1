# ===============================================
# 🎨 Folder Watcher & Auto-Animation Subfolder Creator
# Author: PtiCalin & ChatGPT 🐣
# Version: 2.0
# ===============================================

# ===============================================
# 📜 Usage Guide
# ===============================================
# Button set up:
# Right-click on Desktop > New > Shortcut
# Paste the path to this script in the location field:  
# C:\Users\benny\Dropbox\Family Room\À FAIRE\02-À Jouer\BEN\Watch-And-Create-Animation-Subfolder_v2.ps1
# Name the shortcut: "Start Folder Watcher"
# Optionally, set a custom icon for the shortcut.
# Right-click the shortcut > Properties > Change Icon
# Select an icon from the list or browse to a custom icon file.
# To run the script, double-click the shortcut. It will start monitoring the specified folder for new folders.
# When a new folder is created, it will automatically create a subfolder named "(animation)" within it.
# To stop the script, close the PowerShell window or press Ctrl+C in the PowerShell console.
# Yay! Now you can easily create an "(animation)" subfolder in any new folder you create in the specified path.



# ===============================================
# 🛡 CONFIGURATION
# ===============================================
# Set the path to the folder you want to watch
$watchPath = "C:\Users\benny\Dropbox\Family Room\A FAIRE\02-A Jouer\BEN"

# Dry Run Mode:
# Set the dry run mode (true = no real folder creation, false = real folder creation)
# This is useful for testing the script without making any changes to your file system.
$dryRun = $true  # <<< CHANGE THIS TO $false to allow real folder creation

# ===============================================
# 📝 Intro Message
# ===============================================
# Clear-Host
Write-Host "`n==============================================="
Write-Host "🎯 Folder Watcher is now running..."
Write-Host "🔍 Watching for new folders in:"
Write-Host "    $watchPath"
Write-Host "📂 New folders will receive an '(animation)' subfolder."
if ($dryRun) {
    Write-Host "📝 DRY RUN MODE: No real folders will be created."
} else {
    Write-Host "✅ LIVE MODE: New subfolders will be created automatically."
}
Write-Host "==============================================="

# ===============================================
# 🧐 SAFEGUARD: Validate Watch Path
# ===============================================
# Check if the watch path exists
if (-not (Test-Path $watchPath)) {
    Write-Host "❌ ERROR: The watch path does not exist."
    Write-Host "Please check the folder path and try again."
    exit
}

# ===============================================
# 🔎 Set Up Folder Watcher
# ===============================================
# Create a new FileSystemWatcher object to monitor the specified path
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watchPath
$watcher.Filter = "*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# ===============================================
# ⚡ Event Action: What Happens When a Folder is Created
# ===============================================
# Define the action to take when a new folder is created
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action {

    # Get the path and check what was created
    $fullPath = $Event.SourceEventArgs.FullPath

    # Safeguard: Sometimes creation events are fired before the folder is fully ready
    Start-Sleep -Milliseconds 500

    if (Test-Path $fullPath) {
        $item = Get-Item $fullPath

        # Only act if it's a folder
        if ($item.PSIsContainer) {

            $folderName = $item.Name

            # Check for forbidden characters (Windows invalid characters)
            if ($folderName -match '[\\/:*?"<>|]') {
                Write-Host "⚠️ Skipped folder '$folderName' due to invalid characters."
                return
            }

            $newSubFolder = Join-Path -Path $item.FullName -ChildPath "$folderName (animation)"

            if (-not (Test-Path $newSubFolder)) {
                if ($using:dryRun) {
                    Write-Host "📝 [DRY RUN] Would create subfolder: $newSubFolder"
                } else {
                    New-Item -Path $newSubFolder -ItemType Directory | Out-Null
                    Write-Host "✅ Created subfolder: $newSubFolder"
                }
            } else {
                Write-Host "ℹ️ Subfolder already exists: $newSubFolder"
            }
        } else {
            Write-Host "ℹ️ A file was created, not a folder. Ignoring: $fullPath"
        }
    } else {
        Write-Host "⚠️ Item no longer exists at: $fullPath"
    }
}

# ===============================================
# 👀 Keep Watching
# ===============================================
Write-Host "`n👀 Watching for new folders... Press Ctrl+C to stop.`n"
while ($true) { Start-Sleep -Seconds 10 }
