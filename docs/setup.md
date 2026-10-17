# Environment Setup Guide

This document outlines the steps taken to configure the tools and credentials for the Lead Follow-Up Automation project.

## 1. n8n Setup
- n8n is self-hosted locally using Docker.
- The container is named `n8n` and runs on port `5678`.
- Data is persisted using a Docker volume named `n8n_data`.

## 2. Google Cloud Setup
- Created a dedicated Google Cloud project named `lead-followup-demo`.
- Enabled the **Gmail API** and **Google Sheets API**.
- Configured the OAuth consent screen as "External" and added the demo Gmail address as a test user.
- Created an OAuth 2.0 Client ID (Web application) and added the n8n redirect URLs to the authorized list.

## 3. Telegram Setup
- Created a new bot via @BotFather.
- Retrieved the bot token and identified the agent's Chat ID using the `/getUpdates` endpoint.
