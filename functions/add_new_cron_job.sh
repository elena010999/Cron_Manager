#!/bin/bash

# Define cron fields
fields=("Minute" "Hour" "Day of Month" "Month" "Day of Week" "Command")

# Array to store user inputs
inputs=()

# Loop through each field and prompt user
for i in "${!fields[@]}"; do
    read -rp "Enter ${fields[i]}: " value
    inputs+=("$value")
done

# Build cron job line
cron_job="${inputs[0]} ${inputs[1]} ${inputs[2]} ${inputs[3]} ${inputs[4]} ${inputs[5]}"

echo
echo "Your cron job is:"
echo "$cron_job"

#!/bin/bash

# Define cron fields
fields=("Minute" "Hour" "Day of Month" "Month" "Day of Week" "Command")

# Array to store user inputs
inputs=()

# Loop through each field and prompt user
for i in "${!fields[@]}"; do
    read -rp "Enter ${fields[i]}: " value
    inputs+=("$value")
done

# Build cron job line
cron_job="${inputs[0]} ${inputs[1]} ${inputs[2]} ${inputs[3]} ${inputs[4]} ${inputs[5]}"

echo
echo "Your cron job is:"
echo "$cron_job"

read -rp "Add this cron job? (y/n): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Append new cron job to existing crontab
( crontab -l 2>/dev/null; echo "$cron_job" ) | crontab -

echo "Cron job added successfully!"

