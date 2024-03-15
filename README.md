 # Automated Backup and Rotation Script

## Overview

This script automates the backup process for a GitHub project, implementing a rotational backup strategy, and integrates with Google Drive to push backups. Additionally, it provides options for deletion of older backups and sends a cURL request on successful backup.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Rotational Backup Strategy](#rotational-backup-strategy)
- [Output and Notification](#output-and-notification)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

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

Configuration

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

Usage

Give the permission to your backup.sh

bash

chmod +x backup.sh

Run the script:

bash

./backup_script.sh

Rotational Backup Strategy

A rotational backup strategy is a method of managing backup copies by retaining a set number of recent backups while systematically removing older ones. This strategy provides a balance between conserving storage space and ensuring that you have access to a sufficient history of backup data.

In the context of our script, the rotational backup strategy is implemented with the following characteristics:
Daily Backups:

    Retains the last 'x' daily backups.

Weekly Backups:

    Retains the last 'x' weekly backups.
    In our example, we specified keeping the backups of the last 4 Sundays as a weekly backup.

Monthly Backups:

    Retains the last 'x' monthly backups.
    In our example, we specified keeping the backups of the last 3 months.

Deletion of Older Backups:

    Deletes backups beyond the specified retention periods.
    The retention periods are defined by the 'x' value for daily, weekly, and monthly backups.

Example (with 'x' set to 7 in our Script):

    Keep the backups of the last 7 days.
    Keep the backups of the last 4 Sundays (weekly).
    Keep the backups of the last 3 months.
    Delete older backups beyond the specified retention periods.

This strategy ensures that we have a recent history of backups for quick recovery while gradually removing older backups to free up storage space. The 'x' value provides flexibility in customizing the number of backups retained for each period based on your specific needs. If needed, adjust the rotational backup strategy in the script based on your project requirements.
Output and Notification

The script outputs relevant information, success/failure messages, and timestamps to the console. On successful backup, a cURL request is made to the specified endpoint (CURL_URL) with a POST request containing project name, date, and a test identifier.

Example cURL Request:

bash

curl -X POST -H "Content-Type: application/json" -d '{"project": "YourProjectName", "date": "BackupDate", "test": "BackupSuccessful"}' https://your-webhook-url

Documentation

You can use this content for your README.md file in your GitHub repository.

