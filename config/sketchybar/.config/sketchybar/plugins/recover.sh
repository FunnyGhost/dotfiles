#!/bin/bash

# Keeps the bar right across display changes and sleep. Runs on the
# invisible "recover" item's events.
#
# display_change: reload. Workspaces are assigned to displays when
#   sketchybarrc runs, so a new monitor setup needs a fresh run.
# system_woke: if the bar's windows went missing (the process stays alive,
#   but nothing is drawn, and --reload doesn't fix it), restart sketchybar
#   through launchd. At most once every 5 minutes, logged to recover.log.

CACHE="$HOME/.cache/sketchybar"
mkdir -p "$CACHE"
log() { echo "$(date '+%F %T') $*" >>"$CACHE/recover.log"; }

if [ "$SENDER" = "display_change" ]; then
  # one physical change fires several events; let them settle, reload once
  stamp=$$
  echo "$stamp" >"$CACHE/recover.pending"
  sleep 2
  [ "$(cat "$CACHE/recover.pending")" = "$stamp" ] || exit 0
  log "display change → reload"
  sketchybar --reload
  exit 0
fi

[ "$SENDER" = "system_woke" ] || exit 0

# A drawn item has an on-screen origin; queries are sometimes empty, so only
# five empty answers in a row count
for _ in 1 2 3 4 5; do
  sketchybar --query clock.time 2>/dev/null | grep -q '"origin"' && exit 0
  sleep 1
done

now=$(date +%s)
last=$(cat "$CACHE/recover.last" 2>/dev/null || echo 0)
if [ $((now - last)) -lt 300 ]; then
  log "no windows after wake, restart skipped (last one $((now - last))s ago)"
  exit 0
fi
echo "$now" >"$CACHE/recover.last"
# brew services' label has changed across Homebrew versions; look it up
label=$(launchctl list | awk '/sketchybar/ { print $3; exit }')
log "no windows after wake → restart (${label:-no launchd label})"
[ -n "$label" ] && launchctl kickstart -k "gui/$(id -u)/$label"
