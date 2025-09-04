#!/bin/bash

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

options=("List Existing Cron Jobs" "Add a New Cron Job" "Edit an Existing Cron Job" "Remove a Cron Job" "Enable/Disable Cron Jobs" "Show Cron Service Status")

echo -e "${CYAN}===== Welcome to Linux Cron Manager =====${NC}"
echo

echo -e "${YELLOW}Please select an option:${NC}"
echo "-----------------------------------------"

for i in "${!options[@]}"; do
    echo -e "${GREEN}$((i+1)))${NC} ${options[i]}"
done

echo "-----------------------------------------"
echo

# Read user choice
read -rp "Enter your choice [1-${#options[@]}]: " choice
echo

# Check if choice is valid
if [[ $choice -ge 1 && $choice -le ${#options[@]} ]]; then
    echo -e "${CYAN}You selected: ${options[$((choice-1))]}${NC}"
else
    echo -e "${RED}Invalid option. Please try again.${NC}"
    exit 1
fi

echo "-----------------------------------------"
echo

case $choice in
    1) 
        echo -e "${YELLOW}Calling: List current user's cron jobs...${NC}"
        ./functions/list_existing_cron_job.sh
        ;;
    2) 
        echo -e "${YELLOW}Calling: Add new cron job script...${NC}"
        ./functions/add_new_cron_job.sh
        ;;
    3)
        echo -e "${YELLOW}Calling: Edit existing cron job script...${NC}"
        ./functions/edit_existing_cron_job.sh
        ;;
    4)
        echo -e "${YELLOW}Calling: Remove cron job script...${NC}"
        ./functions/remove_cron_job.sh
        ;;
    5)
        echo -e "${YELLOW}Calling: Enable/Disable cron job script...${NC}"
        ./functions/enable_disable_cron_job.sh
        ;;
    6)
        echo -e "${YELLOW}Calling: Check cron service status script...${NC}"
        ./functions/show_cron_service_status.sh
        ;;
    *) 
        echo -e "${RED}Invalid choice${NC}"
        ;;
esac

echo
echo -e "${CYAN}=========================================${NC}"

