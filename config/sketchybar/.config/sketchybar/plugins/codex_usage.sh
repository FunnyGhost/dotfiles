#!/bin/bash

# Codex plan limits: how much of the 5-hour and weekly windows is left, the
# same numbers the Codex and ChatGPT apps show. Asked live from Codex
# (plugins/codex_limits.py), so use from every app counts. If that fails, the
# last live answer is kept; with none yet, it falls back to the newest session
# log of the last week that recorded them: live ones in ~/.codex/sessions,
# then archived (zstd-compressed) ones.
# Always shown: a window past its reset time, or no data at all, is 100% left.

source "$CONFIG_DIR/theme.sh"

case "$SENDER" in
  mouse.clicked) sketchybar --set codex popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set codex popup.drawing=off; exit 0 ;;
esac

CACHE="$HOME/.cache/sketchybar/codex"
now=$(date +%s)
since=$(date -r $((now - 7 * 86400)) '+%Y-%m-%dT%H-%M-%S')

# Archived logs never change, so each one is unpacked once and its limits kept
archived_limits() {
  local cached="$CACHE/${1##*/}.limits"
  if [ ! -f "$cached" ]; then
    mkdir -p "$CACHE"
    zstd -dcq "$1" 2>/dev/null | grep '"rate_limits":{' | tail -1 | jq -c '.payload.rate_limits' >"$cached"
  fi
  cat "$cached"
}

# used %, reset epoch for both windows: live from Codex; when OpenAI's end
# fails, the last live answer (reset times still apply to it); else the logs
if live=$(python3 -I "$CONFIG_DIR/plugins/codex_limits.py" 2>/dev/null) && [ -n "$live" ]; then
  mkdir -p "$CACHE"
  echo "$live" >"$CACHE/live"
else
  live=$(cat "$CACHE/live" 2>/dev/null)
fi
read -r p5 r5 pw rw <<<"$live"

# Fallback: the newest log that recorded them, newest first by the start time
# in the file name (rollout-2026-11-09T22-02-18-…)
shopt -s nullglob
limits=""
if [ -z "$rw" ]; then
  while read -r log; do
    case "$log" in
      *.zst) limits=$(archived_limits "$log") ;;
      *) limits=$(grep '"rate_limits":{' "$log" | tail -1 | jq -c '.payload.rate_limits') ;;
    esac
    [ -n "$limits" ] && break
  done < <(
    for log in "$HOME"/.codex/sessions/*/*/*/rollout-*.jsonl "$HOME"/.codex/archived_sessions/rollout-*.jsonl*; do
      name=${log##*/rollout-}
      [[ ${name:0:19} > $since ]] && printf '%s\t%s\n' "${name:0:19}" "$log"
    done | sort -r | cut -f2
  )
fi

if [ -z "$rw" ] && [ -n "$limits" ]; then
  read -r p5 r5 pw rw < <(jq -r '[.primary.used_percent, .primary.resets_at,
    .secondary.used_percent, .secondary.resets_at] | map(round) | @tsv' <<<"$limits")
fi

# What's left, as the apps show it. A window past its reset, or no data at
# all (no Codex use this week), is full.
left() { if [ -z "$2" ] || [ "$2" -le "$now" ]; then echo 100; else echo $((100 - $1)); fi; }
l5=$(left "$p5" "$r5")
lw=$(left "$pw" "$rw")

color_for() {
  if [ "$1" -le 10 ]; then echo $RED; elif [ "$1" -le 30 ]; then echo $YELLOW; else echo "$2"; fi
}

resets_in() {
  local s=$((${1:-0} - now))
  if [ "$s" -le 0 ]; then echo "fresh window"
  elif [ "$s" -ge 86400 ]; then echo "resets in $((s / 86400))d $((s % 86400 / 3600))h"
  elif [ "$s" -ge 3600 ]; then echo "resets in $((s / 3600))h $((s % 3600 / 60))m"
  else echo "resets in $((s / 60))m"
  fi
}

# A 28-cell meter of what's left: the filled part is the icon, the rest the
# (dim) label
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
  --set codex.5h drawing=on icon="$l5%" icon.color="$(color_for "$l5" "$TEXT")" \
  --set codex.wk drawing=on icon="$lw%" icon.color="$(color_for "$lw" "$TEXT")" \
  --set codexpop.5h label="$l5% left  ·  $(resets_in "$r5")" \
  --set codexpop.wk label="$lw% left  ·  $(resets_in "$rw")" \
  --set codexpop.5h.bar $(meter "$l5") icon.color="$(color_for "$l5" "$PURPLE")" \
  --set codexpop.wk.bar $(meter "$lw") icon.color="$(color_for "$lw" "$PURPLE")"
