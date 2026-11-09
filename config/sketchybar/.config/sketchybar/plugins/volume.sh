#!/bin/bash

# Volume: the icon shows the level (crossed out when muted), the label the
# percentage. Click: a popup with a slider and a mute switch
# (plugins/volume_ctl.sh).

source "$CONFIG_DIR/theme.sh"

case "$SENDER" in
  mouse.clicked) sketchybar --set volume popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set volume popup.drawing=off; exit 0 ;;
  volume_change) VOLUME=$INFO ;;
  *) VOLUME=$(osascript -e 'output volume of (get volume settings)') ;;
esac
MUTED=$(osascript -e 'output muted of (get volume settings)')

# Nerd Font glyphs as escaped bytes: tools drop them as literal characters
case "$VOLUME" in
  [6-9][0-9] | 100) ICON=$(printf '\363\260\225\276') ;;
  [3-5][0-9]) ICON=$(printf '\363\260\226\200') ;;
  [1-9] | [1-2][0-9]) ICON=$(printf '\363\260\225\277') ;;
  *) ICON=$(printf '\363\260\226\201') ;;
esac

if [ "$MUTED" = true ]; then
  ICON=$(printf '\363\260\226\201')
  mute_label="Muted" mute_color=$RED
else
  mute_label="Mute" mute_color=$DIM
fi

sketchybar --set volume icon="$ICON" label="$VOLUME%" \
  --set volpop.slider slider.percentage="$VOLUME" \
  --set volpop.mute icon="$ICON" icon.color="$mute_color" label="$mute_label"
