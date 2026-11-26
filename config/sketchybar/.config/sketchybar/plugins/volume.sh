#!/bin/bash

# Sound: volume and Bluetooth headphones in one item. Icon: the connected
# pair's own (earbuds or headphones, purple), else the speaker by level; the
# mute icon while muted. Label: the volume. Popup: a slider
# (plugins/volume_ctl.sh), then the headphones and the settings
# (plugins/bluetooth.sh).
#
# What's connected comes from bluetooth.sh's last scan, a cache file, so
# moving the slider doesn't scan Bluetooth. The scan runs every 30s, on wake,
# and when the popup opens; SENDER=refresh redraws from the cache only.

source "$CONFIG_DIR/theme.sh"
BLUETOOTH="$CONFIG_DIR/plugins/bluetooth.sh"

case "$SENDER" in
  mouse.exited.global) sketchybar --set volume popup.drawing=off; exit 0 ;;
  mouse.clicked)
    # a fresh device list, then open; the icon below follows the scan. Only a
    # click on the item itself: a popup row's click arrives as mouse.clicked too
    "$BLUETOOTH" popup
    [ "$NAME" = volume ] && sketchybar --set volume popup.drawing=toggle
    ;;
  routine | forced | system_woke) "$BLUETOOTH" scan ;;
esac

if [ "$SENDER" = volume_change ]; then
  VOLUME=$INFO
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi
MUTED=$(osascript -e 'output muted of (get volume settings)')

# Nerd Font glyphs as escaped bytes: tools drop them as literal characters
MUTE=$(printf '\363\260\226\201')
case "$VOLUME" in
  [6-9][0-9] | 100) SPEAKER=$(printf '\363\260\225\276') ;;
  [3-5][0-9]) SPEAKER=$(printf '\363\260\226\200') ;;
  [1-9] | [1-2][0-9]) SPEAKER=$(printf '\363\260\225\277') ;;
  *) SPEAKER=$MUTE ;;
esac

headphones=$(cat "$HOME/.cache/sketchybar/bt_connected" 2>/dev/null)
if [ "$MUTED" = true ]; then
  icon=$MUTE color=$DIM
else
  icon=${headphones:-$SPEAKER} color=$DIM
  [ -n "$headphones" ] && color=$PURPLE
fi

# While bluetooth.sh connects or disconnects a pair (its marker is under a
# minute old), the icon is its yellow progress: leave it, it refreshes after
busy="$HOME/.cache/sketchybar/bluetooth.busy"
if [ -f "$busy" ] && [ $(($(date +%s) - $(stat -f %m "$busy"))) -lt 60 ]; then
  icon_args=()
else
  icon_args=(icon="$icon" icon.color="$color")
fi

sketchybar --set volume "${icon_args[@]}" label="$VOLUME%" \
  --set volpop.slider slider.percentage="$VOLUME"
