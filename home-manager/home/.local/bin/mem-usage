#!/usr/bin/env sh

used=$(free -m | grep -oP '\d+' | sed '2!d')
total=$(free -m | grep -oP '\d+' | sed '1!d')

echo "$used / $total MiB"
