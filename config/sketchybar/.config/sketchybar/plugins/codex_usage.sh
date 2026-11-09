#!/bin/bash

# Codex plan limits: 5-hour and weekly use. Codex writes them into its session
# logs, but not on every turn, so read the newest log that has them. A window
# whose reset time has passed shows 0%.

source "$CONFIG_DIR/theme.sh"

case "$SENDER" in
  mouse.clicked) sketchybar --set codex popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set codex popup.drawing=off; exit 0 ;;
esac

shopt -s nullglob
logs=("$HOME"/.codex/sessions/*/*/*/rollout-*.jsonl)

limits=""
if [ ${#logs[@]} -gt 0 ]; then
  while read -r log; do
    limits=$(grep '"rate_limits":{' "$log" | tail -1 | jq -c '.payload.rate_limits')
    [ -n "$limits" ] && break
  done < <(ls -t "${logs[@]}" | head -50)
fi

if [ -z "$limits" ]; then
  sketchybar --set '/codex.*/' drawing=off
  exit 0
fi

now=$(date +%s)
read -r p5 r5 pw rw < <(jq -r --argjson now "$now" '
  def used(w): if w.resets_at < $now then 0 else (w.used_percent | round) end;
  [used(.primary), .primary.resets_at, used(.secondary), .secondary.resets_at] | @tsv' <<<"$limits")

color_for() {
  if [ "$1" -ge 90 ]; then echo $RED; elif [ "$1" -ge 70 ]; then echo $YELLOW; else echo "$2"; fi
}

resets_in() {
  local s=$(($1 - now))
  if [ "$s" -le 0 ]; then echo "fresh window"
  elif [ "$s" -ge 86400 ]; then echo "resets in $((s / 86400))d $((s % 86400 / 3600))h"
  elif [ "$s" -ge 3600 ]; then echo "resets in $((s / 3600))h $((s % 3600 / 60))m"
  else echo "resets in $((s / 60))m"
  fi
}

# A 28-cell meter: the filled part is the icon, the rest the (dim) label
WIDTH=28
meter() {
  local filled=$((($1 * WIDTH + 50) / 100)) on="" off="" i
  [ "$1" -gt 0 ] && [ "$filled" -eq 0 ] && filled=1
  for ((i = 0; i < WIDTH; i++)); do
    if [ "$i" -lt "$filled" ]; then on+="━"; else off+="━"; fi
  done
  echo "icon=$on" "label=$off" "icon.drawing=$([ -n "$on" ] && echo on || echo off)"
}

# shellcheck disable=SC2046 # meter() emits several key=value words on purpose
sketchybar --set codex drawing=on \
  --set codex.5h drawing=on icon="$p5%" icon.color="$(color_for "$p5" "$TEXT")" \
  --set codex.wk drawing=on icon="$pw%" icon.color="$(color_for "$pw" "$TEXT")" \
  --set codexpop.5h label="$p5%  ·  $(resets_in "$r5")" \
  --set codexpop.wk label="$pw%  ·  $(resets_in "$rw")" \
  --set codexpop.5h.bar $(meter "$p5") icon.color="$(color_for "$p5" "$PURPLE")" \
  --set codexpop.wk.bar $(meter "$pw") icon.color="$(color_for "$pw" "$PURPLE")"
