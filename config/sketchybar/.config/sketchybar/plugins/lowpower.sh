#!/bin/bash

# Click on the battery popup's Low Power Mode row: flips it, on battery and on
# power alike. pmset needs root, so macOS asks for your password each time.

source "$CONFIG_DIR/theme.sh"

if [ "$(pmset -g | awk '/powermode/ { print $2 }')" = 1 ]; then new=0; else new=1; fi
osascript -e "do shell script \"pmset -a powermode $new\" with administrator privileges" >/dev/null 2>&1 || exit 0

if [ "$new" = 1 ]; then
  sketchybar --set batpop.lowpower icon.color=$GREEN label="Low Power Mode  on"
else
  sketchybar --set batpop.lowpower icon.color=$DIM label="Low Power Mode  off"
fi
