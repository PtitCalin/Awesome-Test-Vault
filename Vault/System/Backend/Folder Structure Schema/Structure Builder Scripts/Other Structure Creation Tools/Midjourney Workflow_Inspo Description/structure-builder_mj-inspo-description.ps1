<# 
-----------------------------------------------------------------------------------
🎨 MidJourney Inspo Batch Folder Builder - PowerShell Version
-----------------------------------------------------------------------------------
USAGE:
    .\mj-inspo-builder.ps1 -Batch 5 -Start 7 [-DryRun]

EXAMPLE:
    .\mj-inspo-builder.ps1 -Batch 3 -Start 42
-----------------------------------------------------------------------------------
#>

param(
    [Parameter(Mandatory = $true)][int]$Batch,
    [Parameter(Mandatory = $true)][int]$Start,
    [switch]$DryRun
)

# === Configuration ===
$BasePath = "."  # Change this to your preferred root directory

Write-Host "🔢 Creating $Batch inspo folders starting at inspo_$('{0:D4}' -f $Start)" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "🧪 DRY-RUN mode enabled. No changes will be made." -ForegroundColor Yellow
}

# === Helper Function ===
function Create-VarFolderAndFile {
    param (
        [string]$Parent,
        [string]$VarName
    )
    $FolderPath = Join-Path $Parent $VarName
    $DescFile = Join-Path $FolderPath "${VarName}_description.txt"

    if ($DryRun) {
        Write-Host "[DRY RUN] Would create folder: $FolderPath"
        Write-Host "[DRY RUN] Would create file: $DescFile"
    }
    else {
        New-Item -Path $FolderPath -ItemType Directory -Force | Out-Null
        New-Item -Path $DescFile -ItemType File -Force | Out-Null
        Write-Host "📁 Created folder: $FolderPath"
        Write-Host "📝 Created file: $DescFile"
    }
}

# === Main Loop ===
for ($i = 0; $i -lt $Batch; $i++) {
    $N = $Start + $i
    $InspoFolder = "inspo_$('{0:D4}' -f $N)"
    $FullPath = Join-Path $BasePath $InspoFolder

    Write-Host "➡ Processing $InspoFolder" -ForegroundColor Green

    if (Test-Path $FullPath) {
        Write-Host "⚠️ Folder already exists: $FullPath" -ForegroundColor Yellow
    }
    else {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create base folder: $FullPath"
        }
        else {
            New-Item -Path $FullPath -ItemType Directory -Force | Out-Null
            Write-Host "📂 Created base folder: $FullPath"
        }
    }

    foreach ($v in 1..4) {
        Create-VarFolderAndFile -Parent $FullPath -VarName "var$v"
    }
}

# === Completion Message ===
if ($DryRun) {
    Write-Host "✅ DRY-RUN complete. No files or folders created." -ForegroundColor Yellow
}
else {
    Write-Host "✅ All $Batch inspo folders created successfully starting at inspo_$('{0:D4}' -f $Start)" -ForegroundColor Cyan
}
Write-Host "✨ All set! Happy creating."

# End of Script

<# 
-----------------------------------------------------------------------------------
This PowerShell script automates batch creation of MidJourney inspo folders.
Each inspo folder contains 4 variant subfolders, each with a description file.
Supports dry-run mode for safe previewing.

# === Notes ===
# - Ensure you have the necessary permissions to create folders and files in the specified path.
# - Adjust the $BasePath variable to point to your desired root directory.
-----------------------------------------------------------------------------------
#>


