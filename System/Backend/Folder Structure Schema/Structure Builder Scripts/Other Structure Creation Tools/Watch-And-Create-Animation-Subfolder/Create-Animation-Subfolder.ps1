$folderName = Split-Path $parentFolder -Leaf
$newSubFolder = Join-Path -Path $parentFolder -ChildPath "$folderName (animation)"

if (-not (Test-Path $newSubFolder)) {
    New-Item -Path $newSubFolder -ItemType Directory
    Write-Output "Created subfolder: $newSubFolder"
} else {
    Write-Output "Subfolder already exists: $newSubFolder"
}
