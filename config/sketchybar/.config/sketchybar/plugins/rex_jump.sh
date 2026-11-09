#!/bin/bash

# Click on an agents popup row: jump to that tab in Rex, the way Wayfinder does,
# and bring Rex forward. Usage: rex_jump.sh <session id> <window id>

source "$CONFIG_DIR/plugins/rex_cmd.sh"

sketchybar --set agents popup.drawing=off
rex do session.select session_id="$1" window_id="$2" >/dev/null 2>&1 &&
  open -a "Rex Beta"
