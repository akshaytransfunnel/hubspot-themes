# HubSpot Theme Upload - Using CLI

This solution uses the official HubSpot CLI to upload your theme with your existing access token.

## Setup (One Time)

### 1. Install HubSpot CLI Globally

```bash
npm install -g @hubspot/cli
```

### 2. Create `.env` File

Create a `.env` file in this directory with your credentials:

```
HUBSPOT_ACCESS_TOKEN=pat-na1-xxxxxxxxxxxxxxxxxxxxx
HUBSPOT_PORTAL_ID=123456789
```

Get your **access token** from: https://app.hubspot.com/l/personal-acc-token/

Get your **portal ID** from your HubSpot URL: `app.hubspot.com/{PORTAL_ID}/...`

## Run Upload

Choose one method:

### Method 1: PowerShell (Recommended)

```bash
pwsh upload.ps1
```

### Method 2: Batch File (Windows)

```bash
upload.bat
```

### Method 3: Node.js

```bash
node upload.js
```

## What It Does

1. Reads `HUBSPOT_ACCESS_TOKEN` from `.env`
2. Authenticates with HubSpot CLI using `hs auth --token`
3. Uploads theme using `hs theme upload`

## Output

You should see:
```
🚀 HubSpot Theme Upload

Portal ID: 123456789
Token: pat-na1-xxxxx...

📝 Step 1: Authenticating with HubSpot CLI...
✅ Authentication successful!

📤 Step 2: Uploading theme...
✅ Theme uploaded successfully!
```

## Troubleshooting

### "HubSpot CLI not found"
- Install globally: `npm install -g @hubspot/cli`
- Verify: `hs --version`

### "Authentication failed"
- Check token in `.env` is valid
- Get new token: https://app.hubspot.com/l/personal-acc-token/

### "Upload failed"
- Make sure you're in the theme directory
- Check theme.json and fields.json exist
- Verify portal ID is correct

## Files

- `upload.ps1` - PowerShell script (works best)
- `upload.bat` - Batch file for Windows
- `upload.js` - Node.js wrapper script
- `.env` - Your credentials (DO NOT COMMIT)

