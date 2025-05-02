$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "C:\Users\benny\Dropbox\Family Room\À FAIRE\02-À Jouer\BEN"
$watcher.Filter = "*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action {
    if (Test-Path $Event.SourceEventArgs.FullPath) {
        $item = Get-Item $Event.SourceEventArgs.FullPath
        if ($item.PSIsContainer) {
            $folderName = $item.Name
            $newSubFolder = Join-Path -Path $item.FullName -ChildPath "$folderName (animation)"
            if (-not (Test-Path $newSubFolder)) {
                New-Item -Path $newSubFolder -ItemType Directory
                Write-Output "Created subfolder: $newSubFolder"
            }
        }
    }
}

Write-Output "Watching for new folders... Press Ctrl+C to stop."
while ($true) { Start-Sleep -Seconds 10 }
