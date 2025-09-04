#!/bin/bash

# Load current crontab into array
mapfile -t cron_lines < <(crontab -l 2>/dev/null)

if [ ${#cron_lines[@]} -eq 0 ]; then
    echo "No cron jobs found for user $(whoami)."
    exit 1
fi

echo "Your current cron jobs:"
for i in "${!cron_lines[@]}"; do
    echo "$((i + 1)). ${cron_lines[$i]}"
done

read -rp $'\nSelect cron job to edit (1-N): ' selection
index=$((selection - 1))

# Validate selection
if [ "$index" -lt 0 ] || [ "$index" -ge "${#cron_lines[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

selected="${cron_lines[$index]}"
read -r min hour dom mon dow command <<<"$selected"
fields=("Minute" "Hour" "Day of Month" "Month" "Day of Week" "Command")
values=("$min" "$hour" "$dom" "$mon" "$dow" "$command")

# Simple edit loop
while true; do
    echo -e "\nWhich field do you want to edit?"
    for i in "${!fields[@]}"; do
        echo "$((i + 1)). ${fields[i]} (current: ${values[i]})"
    done

    read -rp $'\nEnter number to edit: ' field_num
    field_index=$((field_num - 1))

    if [ "$field_index" -lt 0 ] || [ "$field_index" -ge "${#fields[@]}" ]; then
        echo "Invalid field."
        continue
    fi

    read -rp "Enter new value for ${fields[$field_index]}: " new_value
    values[$field_index]="$new_value"

    read -rp "Edit another field? (y/n): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || break
done

# Rebuild and save
new_cron="${values[0]} ${values[1]} ${values[2]} ${values[3]} ${values[4]} ${values[5]}"
cron_lines[$index]="$new_cron"
printf "%s\n" "${cron_lines[@]}" | crontab -

echo -e "\nCron job updated to:"
echo "$new_cron"

