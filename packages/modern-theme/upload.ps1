#!/usr/bin/env pwsh

# HubSpot Theme Upload Script
# Runs HubSpot CLI commands from Node.js/PowerShell
# 
# Usage: pwsh upload.ps1

param(
    [string]$TokenParam = $null,
    [string]$PortalParam = $null
)

# Load .env file
$envFile = ".env"
if (Test-Path $envFile) {
    Write-Host "📝 Loading credentials from .env..." -ForegroundColor Cyan
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^=]+)\s*=\s*(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($key, $value)
        }
    }
}

$accessToken = $TokenParam -or [System.Environment]::GetEnvironmentVariable('HUBSPOT_ACCESS_TOKEN')
$portalId = $PortalParam -or [System.Environment]::GetEnvironmentVariable('HUBSPOT_PORTAL_ID')

if (-not $accessToken) {
    Write-Host "❌ Error: HUBSPOT_ACCESS_TOKEN not found" -ForegroundColor Red
    Write-Host "Please set HUBSPOT_ACCESS_TOKEN in .env file" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🚀 HubSpot Theme Upload" -ForegroundColor Green
Write-Host ""
if ($portalId) {
    Write-Host "Portal ID: $portalId" -ForegroundColor Cyan
}
if ($accessToken) {
    $tokenPreview = if ($accessToken.Length -gt 20) { $accessToken.Substring(0,20) + "..." } else { "***" }
    Write-Host "Token: $tokenPreview" -ForegroundColor Cyan
}
Write-Host ""

try {
    # Check if HubSpot CLI is installed
    Write-Host "📝 Step 1: Checking HubSpot CLI..." -ForegroundColor Cyan
    $hsVersion = & hs --version 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        throw "HubSpot CLI not found or not accessible"
    }
    
    Write-Host "✅ HubSpot CLI found: $hsVersion" -ForegroundColor Green
    Write-Host ""

    # Authenticate with HubSpot CLI
    Write-Host "📝 Step 2: Authenticating with access token..." -ForegroundColor Cyan
    & hs auth --token $accessToken
    
    if ($LASTEXITCODE -ne 0) {
        throw "Authentication failed"
    }
    
    Write-Host "✅ Authentication successful!" -ForegroundColor Green
    Write-Host ""

    # Upload the theme
    Write-Host "📤 Step 3: Uploading theme..." -ForegroundColor Cyan
    & hs theme upload
    
    if ($LASTEXITCODE -ne 0) {
        throw "Theme upload failed"
    }
    
    Write-Host ""
    Write-Host "✅ Theme uploaded successfully!" -ForegroundColor Green
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Install HubSpot CLI globally:" -ForegroundColor Yellow
    Write-Host "   npm install -g @hubspot/cli" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Verify HUBSPOT_ACCESS_TOKEN in .env" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "3. Run the script:" -ForegroundColor Yellow
    Write-Host "   pwsh upload.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}
