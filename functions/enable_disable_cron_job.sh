#!/bin/bash

# Load current crontab into array
mapfile -t cron_lines < <(crontab -l 2>/dev/null)

if [ ${#cron_lines[@]} -eq 0 ]; then
    echo "No cron jobs found for user $(whoami)."
    exit 0
fi

echo "Your current cron jobs:"
for i in "${!cron_lines[@]}"; do
    echo "$((i + 1)). ${cron_lines[$i]}"
done

read -rp $'\nChoose job to enable/disable by line number (1-N): ' line_number
index=$((line_number - 1))

# Validate selection
if [[ ! "$line_number" =~ ^[0-9]+$ ]] || [ "$index" -lt 0 ] || [ "$index" -ge "${#cron_lines[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

current_line="${cron_lines[$index]}"

if [[ "$current_line" =~ ^# ]]; then
    # Line is disabled, enable it by removing the leading '#'
    new_line="${current_line#\#}"
    action="enabled"
else
    # Line is enabled, disable it by adding '#'
    new_line="#$current_line"
    action="disabled"
fi

echo -e "\nCurrent line:"
echo "$current_line"
echo -e "\nIt will be $action to:"
echo "$new_line"

read -rp "Confirm? (y/n): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Update the line in array
cron_lines[$index]="$new_line"

# Save updated crontab
printf "%s\n" "${cron_lines[@]}" | crontab -

echo "Cron job $action successfully."

