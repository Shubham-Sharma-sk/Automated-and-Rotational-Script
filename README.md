# Automated Backup and Rotation Script

## Overview

This script automates the backup process for a GitHub project, implementing a rotational backup strategy, and integrates with Google Drive to push backups. Additionally, it provides options for deletion of older backups and sends a cURL request on successful backup.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Usage](#usage)
5. [Rotational Backup Strategy](#rotational-backup-strategy)
6. [Output and Notification](#output-and-notification)
7. [Documentation](#documentation)
8. [Contributing](#contributing)
9. [License](#license)

## Prerequisites

- Git
- Google Drive CLI tool (e.g., rclone)
- cURL (Webhook.sit)
- Basic Understanding of Linux

## Installation

Clone the repository:

```bash
git clone https://github.com/Shubham-Sharma-sk/Automated-and-Rotational-Script.git
cd Automated-Backup-Script

sudo apt-get install rclone

## configuration

Edit the script (backup_script.sh) and set the following variables:

    repo: URL of the GitHub repository.
    local_folder: Local path to clone the GitHub repository.
    backup: Local path to store backups.
    backup_daily: Local path to store daily backups.
    backup_weekly: Local path to store weekly backups.
    backup_monthly: Local path to store monthly backups.
    rclone_server: Name of the rclone remote for Google Drive.
    gdrive_folder: Google Drive folder ID or name to store backups.
    gdrive_daily: Google Drive folder ID or name to store daily backups.
    gdrive_weekly: Google Drive folder ID or name to store weekly backups.
    gdrive_monthly: Google Drive folder ID or name to store monthly backups.
    rotational_count: Number of backups to retain in each category.
    curl_url: cURL endpoint for successful backup notifications(Webhook).
