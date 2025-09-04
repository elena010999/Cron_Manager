#!/bin/bash

# Load current crontab into an array
mapfile -t cron_lines < <(crontab -l 2>/dev/null)

# Check if there are any cron jobs
if [ ${#cron_lines[@]} -eq 0 ]; then
    echo "No cron jobs found for user $(whoami)."
    exit 0
fi

# Display current cron jobs with line numbers
echo "Your current cron jobs:"
echo "------------------------"
for i in "${!cron_lines[@]}"; do
    echo "$((i + 1)). ${cron_lines[$i]}"
done

# Prompt for line number to delete
read -rp $'\nChoose job to delete by line number (1-N): ' line_number
index=$((line_number - 1))

# Validate selection
if [[ ! "$line_number" =~ ^[0-9]+$ ]] || [ "$index" -lt 0 ] || [ "$index" -ge "${#cron_lines[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

# Confirm deletion
echo -e "\nYou are about to delete:"
echo "${cron_lines[$index]}"
read -rp "Are you sure? (y/n): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Remove the selected line
unset 'cron_lines[index]'

# Save updated crontab
printf "%s\n" "${cron_lines[@]}" | crontab -

echo "Cron job removed successfully."

