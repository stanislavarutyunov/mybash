#!/bin/bash

# Проверка настроек в файле /etc/cron.daily/swap_wipe
swap_wipe_file="/etc/cron.daily/swap_wipe"

if [ ! -f $swap_wipe_file ]; then
  echo "swap_wipe file not found"
  exit 1
fi

# Check if the file contains the expected parameters
if grep -Fxq "sync ; echo 3 > /proc/sys/vm/drop_caches" $swap_wipe_file && grep -Fxq "swapoff -a; swapon -a" $swap_wipe_file; then
  echo "The swap_wipe file contains the expected parameters"
else
  # Update the file with the expected parameters
  echo "sync ; echo 3 > /proc/sys/vm/drop_caches" > $swap_wipe_file
  echo "swapoff -a; swapon -a" >> $swap_wipe_file
  echo "Updated the swap_wipe file with the expected parameters"
  echo "Please check and validate the changes"
fi