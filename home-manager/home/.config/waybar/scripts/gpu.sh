#!/usr/bin/env sh


used=$(cat /sys/class/hwmon/hwmon3/device/mem_info_vram_used)
total=$(cat /sys/class/hwmon/hwmon3/device/mem_info_vram_total)
# convert to MiB
used=$((used / 1048576))
total=$((total / 1048576))
# percent=$(cat /sys/class/hwmon/hwmon3/device/gpu_busy_percent)
# echo "$percent %"

echo "$used / $total MiB"
