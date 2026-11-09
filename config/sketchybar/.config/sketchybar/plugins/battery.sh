#!/bin/bash

# Battery level: the icon shows the charge and takes its colour (cyan while
# charging), the label the percentage. Click: a popup with the time left and
# a Low Power Mode switch (plugins/lowpower.sh).

source "$CONFIG_DIR/theme.sh"

case "$SENDER" in
  mouse.exited.global) sketchybar --set battery popup.drawing=off; exit 0 ;;
  mouse.clicked)
    # pmset: "82%; discharging; 6:52 remaining" → "discharging · 6:52 left"
    state=$(pmset -g batt | awk -F'; *' 'NR == 2 { sub(/ present.*/, "", $3); print $2 " · " $3 }' |
      sed -e 's/ remaining$/ left/' -e 's/(no estimate)/estimating/' -e 's/ · 0:00 left$//')
    if [ "$(pmset -g | awk '/powermode/ { print $2 }')" = 1 ]; then
      lp_color=$GREEN lp_label="Low Power Mode  on"
    else
      lp_color=$DIM lp_label="Low Power Mode  off"
    fi
    sketchybar --set batpop.state label="$state" \
      --set batpop.lowpower icon.color="$lp_color" label="$lp_label" \
      --set battery popup.drawing=toggle
    exit 0
    ;;
esac

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Nerd Font battery glyphs as escaped bytes: tools drop them as literal characters
case "${PERCENTAGE}" in
  9[0-9] | 100) ICON=$(printf '\357\211\200') COLOR=$GREEN ;;
  [6-8][0-9]) ICON=$(printf '\357\211\201') COLOR=$GREEN ;;
  [3-5][0-9]) ICON=$(printf '\357\211\202') COLOR=$YELLOW ;;
  [1-2][0-9]) ICON=$(printf '\357\211\203') COLOR=$ORANGE ;;
  *) ICON=$(printf '\357\211\204') COLOR=$RED ;;
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=$(printf '\357\203\247')
  COLOR=$CYAN
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
