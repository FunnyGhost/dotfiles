#!/bin/bash

# Click on the cat: CPU, memory and disk, read at the moment of the click.

case "$SENDER" in
  mouse.exited.global) sketchybar --set cat popup.drawing=off; exit 0 ;;
  mouse.clicked) ;;
  *) exit 0 ;;
esac

cpu=$(ps -A -o %cpu= | awk -v n="$(sysctl -n hw.ncpu)" '{ s += $1 } END { printf "%d", s / n }')
mem=$(memory_pressure -Q | awk '/percentage/ { sub("%", "", $NF); print 100 - $NF }')
disk=$(df -H /System/Volumes/Data | awk 'NR == 2 { print $4 }')

sketchybar --set catpop.cpu label="$cpu%" \
  --set catpop.mem label="$mem% used" \
  --set catpop.disk label="${disk}B free" \
  --set cat popup.drawing=toggle
