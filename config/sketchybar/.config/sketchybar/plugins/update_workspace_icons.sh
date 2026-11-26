#!/bin/bash

# Sets each workspace item's label to the icons of the apps in it. Run by
# sketchybarrc on start and by AeroSpace on every workspace change.

CONFIG_DIR="$HOME/.config/sketchybar"

update_space_icons() {
  local sid=$1
  local apps icons=""
  # one icon per app, however many windows it has open there
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}')

  if [ -n "$apps" ]; then
    while read -r app; do
      icons+="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app") "
    done <<<"$apps"
    sketchybar --set "space.$sid" label="${icons% }" label.drawing=on icon.padding_right=4 >/dev/null 2>&1
  else
    # an empty workspace is just its number
    sketchybar --set "space.$sid" label.drawing=off icon.padding_right=9 >/dev/null 2>&1
  fi
}

# workspaces without an item (6 and 7 on one monitor) are skipped quietly
for sid in $(aerospace list-workspaces --all); do
  update_space_icons "$sid"
done
