@echo off
REM HubSpot Theme Upload - Batch wrapper
REM This script runs HubSpot CLI commands with the access token

setlocal enabledelayedexpansion

REM Load environment variables from .env
for /f "tokens=1,2 delims==" %%A in (.env) do (
  set "%%A=%%B"
)

if not defined HUBSPOT_ACCESS_TOKEN (
  echo Error: HUBSPOT_ACCESS_TOKEN not found in .env
  exit /b 1
)

echo.
echo Uploading HubSpot Theme...
echo.

REM Authenticate with HubSpot CLI
echo Step 1: Authenticating...
call hs auth --token %HUBSPOT_ACCESS_TOKEN%

if errorlevel 1 (
  echo.
  echo Error: Authentication failed
  echo Make sure HubSpot CLI is installed: npm install -g @hubspot/cli
  exit /b 1
)

echo.
echo Step 2: Uploading theme...
call hs theme upload

if errorlevel 1 (
  echo.
  echo Error: Upload failed
  exit /b 1
)

echo.
echo Success! Theme uploaded.
echo.
