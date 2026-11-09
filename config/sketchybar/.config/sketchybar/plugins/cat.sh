#!/bin/bash

# Long-running: animates the cat, faster the busier the CPU (0.6s a frame
# idle, 0.12s at 80% or more). Started (and restarted on reload) by
# sketchybarrc; ends when sketchybar quits. Frames come from cat_frames.py,
# redrawn into ~/.cache whenever it changes.

FRAMES="$HOME/.cache/sketchybar/cat"
if [ ! -f "$FRAMES/cat_4.png" ] || [ "$CONFIG_DIR/plugins/cat_frames.py" -nt "$FRAMES/cat_1.png" ]; then
  # 3px per cell: 1.5pt on Retina, about 48x26pt on the bar
  python3 -I "$CONFIG_DIR/plugins/cat_frames.py" "$FRAMES" 3 || exit 1
fi

cores=$(sysctl -n hw.ncpu)
cpu=0
frame=1
tick=0

while :; do
  # every ~2s: CPU use across all cores, and check sketchybar is still there
  if [ $((tick % 8)) -eq 0 ]; then
    pgrep -qx sketchybar || exit 0
    cpu=$(ps -A -o %cpu= | awk -v n="$cores" '{ s += $1 } END { printf "%d", s / n }')
  fi
  tick=$((tick + 1))

  sketchybar --set cat icon.background.image="$FRAMES/cat_$frame.png" 2>/dev/null
  frame=$((frame % 4 + 1))

  if [ "$cpu" -ge 80 ]; then
    sleep 0.12
  else
    sleep "$(awk -v c="$cpu" 'BEGIN { printf "%.2f", 0.6 - c * 0.006 }')"
  fi
done
