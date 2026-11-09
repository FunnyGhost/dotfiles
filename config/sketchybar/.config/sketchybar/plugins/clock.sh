#!/bin/sh

# Date (dim) and time (bright) as two items, so they can differ in colour.
# Click either: today's agenda, filled in by plugins/calendar.sh.

case "$SENDER" in
  mouse.clicked) sketchybar --set clock.time popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set clock.time popup.drawing=off; exit 0 ;;
esac

sketchybar --set clock.date label="$(date '+%a %d %b')" \
  --set clock.time label="$(date '+%H:%M')"
