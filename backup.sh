# Here We Provide all the paths
repo="https://github.com/Shubham-Sharma-sk/My-portfolio-.git"
local_folder="/home/shubham/Desktop/Task/Github"
backup="/home/shubham/Desktop/Task/Backup"
backup_daily="$backup/daily"
backup_weekly="$backup/weekly"
backup_monthly="$backup/monthly"
rclone_server="Test"
gdrive_daily="Test/daily"
gdrive_weekly="Test/weekly"
gdrive_monthly="Test/monthly"
log_file="$backup/log_file.txt"
curl_url="https://webhook.site/c5bed560-92c2-4dc9-b007-09e294ba71e8"
daily_rotation_count=7
weekly_rotation_count=4
monthly_rotation_count=3
enable_curl=true 
# Defining the log function
log_message() {

local message="$1"
local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "[${timestamp}] ${message}" >> "$log_file"
}
# Github clone function to clone the repo
github_clone() {

       TIMESTAMP=$(date +"%Y%m%d%H%M%S")
       daily_clone_folder="${local_folder}_${TIMESTAMP}"
       git clone  "${repo}" "${daily_clone_folder}"
       if [ $? -ne 0 ]; then
       log_message "Error Clonning repo  ${repo}  to ${daily_clone_folder}" 
       fi
       }
 # calling daily backup function to create daily backups
daily_backup() {

	TIMESTAMP=$(date +"%Y%m%d%H%M%S")
         backup_name="backup_${TIMESTAMP}.zip"
        zip -r "${backup_daily}/${backup_name}" "${local_folder}"
         log_message "Daily local backup completed: ${backup_name}"
# Calling push function to push the code to gdrive
        push "${backup_name}" "daily"
        log_message "Daily Backup push to gdrive  Completed: ${backup_name}"
# Calling rotation function for rotation
        rotation "${backup_daily}"  "${daily_rotation_count}"  "${gdrive_daily}"     "daily"
	}
# Declaring and calling weekly function
weekly_backup() {
       if [ "$(date +%u)" -eq 7 ]; then
       log_message "Today is Sunday. Performing weekly backup..."
       latest_file=$(find "${backup_daily}" -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d ' ' -f 2)
       if [ -n "${latest_file}" ]; then
      file_name=$(basename "${latest_file}")
       cp "${latest_file}" "${backup_weekly}/${file_name}"
       log_message "Latest file '${file_name}' copied from daily to weekly folder."
# Calling push function
       push "${file_name}" "weekly"
       log_message "Weekly Backup push to gdrive  Completed: ${file_name}"
# Calling rotation function
       rotation "${backup_weekly}"  "${weekly_rotation_count}"  "${gdrive_weekly}"     "weekly"
       else
       log_message "No files found in the daily folder."
       fi
       log_message "Weekly backup completed."


       log_message "Today is not Sunday. No weekly backup needed."
       fi
}
# Declaring and calling monthly backupsfunction
monthly_backup() {

       current_day=$(date +"%d")
       #last_day=$(date -d "$(date -d "$current_day/1 + 1 month" +"%Y-%m-01") - 1 day" +"%d")
       last_day=$(date -d "$(date -d "+1 month" +"%Y-%m-01") - 1 day" +"%d")

       if [ "$current_day" -eq "$last_day" ]; then
       log_message "Today is the last day of the month. Starting monthly backup..."
       latest_file=$(ls -1t "${backup_daily}" | head -n 1)
       if [ -n "${latest_file}" ]; then
       log_message "Latest file in daily folder: ${latest_file}"
       cp "${backup_daily}/${latest_file}" "${backup_monthly}/"
       log_message "File copied to monthly folder:${latest_file}"
# Calling push function
       push "${latest_file}" "monthly"
       log_message "Monthly Backup push to gdrive  Completed: ${latest_file}"
# Calling rotation function
       rotation "${backup_monthly}"  "${monthly_rotation_count}"  "${gdrive_monthly}"     "monthly"
       else
       log_message "No files found in the daily folder."
       fi
       else
       log_message "Today is not the last day of the month. Skipping monthly backup."
       fi
       }

push() {

       file_name="$1"
       local frequency="$2"
       case "$frequency" in
       daily) rclone -v copy "${backup_daily}/${file_name}" "${rclone_server}:${gdrive_daily}" ;;
       weekly) rclone -v copy "${backup_weekly}/${file_name}" "${rclone_server}:${gdrive_weekly}" ;;
       monthly) rclone -v copy "${backup_monthly}/${file_name}" "${rclone_server}:${gdrive_monthly}" ;;
       *) echo "Invalid frequency. Please use 'daily', 'weekly', or 'monthly'." ;;
       esac
       }

rotation() {
            backup_folder="$1"
            rotation_count="$2"
            gdrive_folder="$3"
            backup_type_message="$4"
        # Delete local rotation files
       find "${backup_folder}" -type f -name "backup_*.zip" -exec ls -1t {} + | awk -v threshold="${rotation_count}" 'NR>threshold' | xargs -I {} rm -f {}
       # Get the list of rotation files from the remote server and delete it
       rotation_files=$(rclone ls "${rclone_server}:${gdrive_folder}" --max-depth 1 --dry-run | sort -k 6,7 -r | awk -v threshold="${rotation_count}" 'NR>threshold' | awk '{print $2}')
       
     if [ -n "$rotation_files" ]; then
       for file in $rotation_files; do
      rclone delete "${rclone_server}:${gdrive_folder}/${file}" >> "$log_file" 2>&1
      # Check the exit status of the last command
      if [ $? -ne 0 ]; then
      log_message "Error deleting file: ${file}"
      else
      log_message "Successfully Deleted the ${backup_type_message} rotation: ${file}"
      fi
      done
      else 
      log_message "No eligible files to delete for ${backup_type_message} rotation"
      fi
      }
# Defining curl request 
 curl_request() {

      if [ "${enable_curl}" = true ]; then

      curl -X POST -H "Content-Type: application/json" -d '{"project": "Automated Backup and Rotation Script", "date": "'"${timestamp}"'", "test": "Backup_Successful"}' "${curl_url}"
      else
      log_message "Dry run: cURL request not sent."
      fi
}
# Main execution
log_message "Backup and Rotation Process Started..."
github_clone
daily_backup
weekly_backup
monthly_backup
curl_request
log_message "Backup and Rotation Process Completed..."
