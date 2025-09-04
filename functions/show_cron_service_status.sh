#!/bin/bash

if systemctl is-active --quiet cron; then
    echo "Cron service is running."
else
    echo "Cron service is NOT running."
fi

