#!/usr/bin/env bash

# Focus styling for a workspace item: highlighted with a bright number when
# focused, dim otherwise. Usage: aerospace.sh <workspace id>

source "$CONFIG_DIR/theme.sh"

# --update and system events run this without FOCUSED_WORKSPACE; ask AeroSpace
focused=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}

if [ "$1" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color=$PURPLE label.color=$TEXT
else
  sketchybar --set "$NAME" background.drawing=off icon.color=$DIM label.color=$DIM
fi
