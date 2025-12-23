#!/usr/bin/env node

/**
 * HubSpot Theme Upload - Simple CLI Wrapper
 * 
 * This script runs HubSpot CLI commands with your access token
 * 
 * Usage:
 *   node upload.js
 * 
 * Prerequisites:
 *   npm install -g @hubspot/cli
 *   
 * Environment:
 *   Set HUBSPOT_ACCESS_TOKEN in .env or terminal
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

// Load .env
require('dotenv').config();

const token = process.env.HUBSPOT_ACCESS_TOKEN;
const portalId = process.env.HUBSPOT_PORTAL_ID;

if (!token || token === 'your_access_token_here') {
  console.error('\n❌ Error: HUBSPOT_ACCESS_TOKEN not set in .env\n');
  process.exit(1);
}

console.log('\n🚀 HubSpot Theme Upload\n');
console.log(`Token: ${token.substring(0, 20)}...`);
if (portalId && portalId !== 'your_portal_id_here') {
  console.log(`Portal: ${portalId}`);
}
console.log('\n� Uploading theme...\n');

// Set up environment variables for authentication
const env = { ...process.env };
env.HUBSPOT_PERSONAL_ACCESS_KEY = token;
if (portalId && portalId !== 'your_portal_id_here') {
  env.HUBSPOT_PORTAL_ID = portalId;
}

// Run: hs cms upload . <dest> --use-env
// Using . as src uploads the entire current directory to the themes folder
const upload = spawn('hs', ['cms', 'upload', '.', 'themes/my-theme', '--use-env', '--force'], {
  stdio: 'inherit',
  shell: true,
  cwd: process.cwd(),
  env: env
});

upload.on('close', (code) => {
  console.log('\n');
  if (code === 0) {
    console.log('✅ Theme uploaded successfully!\n');
  } else {
    console.log('❌ Upload failed\n');
    process.exit(1);
  }
});
