# Copy-FsTx-To-SVI.ps1
# Run as Administrator

$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    pause
    exit
}

$localSource = "C:\FsTx"

if (-not (Test-Path $localSource)) {
    Write-Host "Source folder not found: $localSource" -ForegroundColor Red
    pause
    exit
}

Write-Host ""
Write-Host "Choose an option:" -ForegroundColor Cyan
Write-Host "1. New drive"
Write-Host "2. Rebuild drive"
$mode = Read-Host "Enter 1 or 2"

if ($mode -notin @("1", "2")) {
    Write-Host "Invalid option." -ForegroundColor Red
    pause
    exit
}

Write-Host ""
Write-Host "Available drives:" -ForegroundColor Cyan
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root, Description

Write-Host ""
$driveLetter = Read-Host "Enter the USB drive letter only, for example E"
$driveLetter = $driveLetter.TrimEnd(":")
$usbRoot = "$driveLetter`:\"

$sviDir = Join-Path $usbRoot "System Volume Information"
$destDir = Join-Path $sviDir "FsTx"

if (-not (Test-Path $usbRoot)) {
    Write-Host "Drive $usbRoot does not exist." -ForegroundColor Red
    pause
    exit
}

if (-not (Test-Path $sviDir)) {
    Write-Host "System Volume Information folder not found. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $sviDir -Force | Out-Null
}

Write-Host ""
Write-Host "Taking ownership of System Volume Information..." -ForegroundColor Cyan
takeown /F "$sviDir" /R /D Y

Write-Host ""
Write-Host "Granting Administrators full control..." -ForegroundColor Cyan
icacls "$sviDir" /grant Administrators:F /T /C

if ($mode -eq "1") {
    if (Test-Path $destDir) {
        Write-Host ""
        Write-Host "FsTx already exists on this drive:" -ForegroundColor Red
        Write-Host $destDir
        Write-Host "Use the rebuild option if you want to replace it."
        pause
        exit
    }

    Write-Host ""
    Write-Host "Copying FsTx from C:\ to System Volume Information..." -ForegroundColor Cyan
    Copy-Item -Path $localSource -Destination $sviDir -Recurse -Force
}

if ($mode -eq "2") {
    if (Test-Path $destDir) {
        Write-Host ""
        Write-Host "Removing existing FsTx from System Volume Information..." -ForegroundColor Yellow
        Remove-Item -Path $destDir -Recurse -Force
    } else {
        Write-Host ""
        Write-Host "No existing FsTx folder found. Continuing with fresh copy..." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Copying fresh FsTx from C:\ to System Volume Information..." -ForegroundColor Cyan
    Copy-Item -Path $localSource -Destination $sviDir -Recurse -Force
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Source:"
Write-Host "  $localSource"
Write-Host "Destination:"
Write-Host "  $destDir"

pause