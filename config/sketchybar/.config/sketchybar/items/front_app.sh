#!/bin/bash

# The focused app: its icon and name, in its own pill. Click: Mission Control.

front_app=(
  display=active
  padding_left=8
  padding_right=10
  icon.background.drawing=on
  icon.background.image.scale=0.5
  icon.padding_right=2
  label.font="$FONT:Bold:13.0"
  label.color=$PURPLE
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)
sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched \
  --add bracket front_app.pill front_app \
  --set front_app.pill "${pill[@]}" display=active
