#!/bin/bash

# Next meeting, folded into the clock: while an event is on (cyan, "now") or
# starts within 15 minutes (yellow, "in 8m"), clock.event shows it in place of
# the date; otherwise it's just date and time. The clock's popup lists the
# rest of today: meetings get a camera and open their call, other events open
# in Calendar.app. Reads Calendar.app, so it needs Calendar access (System
# Settings › Privacy & Security › Calendars › sketchybar).
#
# Demo: touch ~/.cache/sketchybar/calendar.demo to show made-up events
# instead (rm it to go back). Nothing is written to your calendars.
#
# helper/events.swift does the reading; it's built here on first use, and
# again whenever it changes, into ~/.cache (never into the repo).

source "$CONFIG_DIR/theme.sh"

case "$SENDER" in
  mouse.clicked) sketchybar --set clock.time popup.drawing=toggle; exit 0 ;;
esac

CACHE="$HOME/.cache/sketchybar"
BIN="$CACHE/events"
SRC="$CONFIG_DIR/helper/events.swift"
PLIST="$CONFIG_DIR/helper/Info.plist"

CAMERA=$(printf '\363\260\225\247')   # md-video
CALENDAR=$(printf '\363\260\203\260') # md-calendar_clock

now=$(date +%s)

if [ -f "$CACHE/calendar.demo" ]; then
  # start offset, length (minutes), title, meeting URL
  events=$(
    while IFS='|' read -r offset length title url; do
      start=$((now + offset * 60))
      printf '%s\t%s\t%s\t%s\t\n' "$start" "$((start + length * 60))" "$title" "$url"
    done <<'EOF'
-10|30|Design sync|https://meet.google.com/abc-defg-hij
8|25|1:1 with Alex|https://zoom.us/j/123456789
45|60|Focus: sketchybar|
120|30|Team standup|https://teams.microsoft.com/l/meetup-join/demo
200|45|Lunch & learn: Rust|
EOF
  )
else
  if [ ! -x "$BIN" ] || [ "$SRC" -nt "$BIN" ] || [ "$PLIST" -nt "$BIN" ]; then
    mkdir -p "$CACHE"
    swiftc -O "$SRC" -o "$BIN.$$" \
      -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker "$PLIST" 2>/dev/null &&
      mv -f "$BIN.$$" "$BIN" || { rm -f "$BIN.$$"; exit 0; }
  fi
  events=$("$BIN" 2>/dev/null)
  if [ $? -eq 2 ]; then
    echo "$(date '+%F %T') no Calendar access" >"$CACHE/calendar.log"
  else
    rm -f "$CACHE/calendar.log"
  fi
fi

args=(--remove '/calpop\.row\..*/')

if [ -z "$events" ]; then
  sketchybar "${args[@]}" --add item calpop.row.0 popup.clock.time \
    --set calpop.row.0 "${row[@]}" icon.drawing=off label="Nothing left today" label.color=$DIM \
    label.font="$FONT:Regular:12.0" label.padding_left=12 label.padding_right=12 \
    --add item calpop.row.pad popup.clock.time --set calpop.row.pad "${popup_pad[@]}" \
    --set clock.event drawing=off --set clock.date drawing=on
  exit 0
fi

# What a click runs: open the call if there is one, else the event, else
# just Calendar.app (demo events have no event link)
open_cmd() {
  local url=${1:-$2}
  if [ -n "$url" ]; then echo "open '${url//\'/}'"; else echo "open -a Calendar"; fi
}

i=0
while IFS=$'\t' read -r start _ title meet event; do
  if [ "$start" -le "$now" ]; then color=$CYAN; else color=$TEXT; fi
  if [ -n "$meet" ]; then glyph=$CAMERA; else glyph=$CALENDAR; fi
  args+=(--add item "calpop.row.$i" popup.clock.time
    --set "calpop.row.$i" "${row[@]}" icon="$(date -r "$start" '+%H:%M')" icon.color="$color"
    icon.font="$FONT:Bold:12.0" icon.width=56 icon.padding_left=12
    label="$glyph  ${title:0:40}" label.font="$FONT:Regular:12.0" label.padding_right=12
    click_script="$(open_cmd "$meet" "$event"); sketchybar --set clock.time popup.drawing=off")
  i=$((i + 1))
done <<<"$events"
args+=(--add item calpop.row.pad popup.clock.time --set calpop.row.pad "${popup_pad[@]}")

IFS=$'\t' read -r start _ title meet _ <<<"$(head -1 <<<"$events")"
mins=$(((start - now + 59) / 60))
if [ "$start" -le "$now" ]; then
  when="now" color=$CYAN
elif [ "$mins" -le 15 ]; then
  when="in ${mins}m" color=$YELLOW
else
  # nothing soon: just date and time
  sketchybar "${args[@]}" --set clock.event drawing=off --set clock.date drawing=on
  exit 0
fi
[ ${#title} -gt 22 ] && title="${title:0:21}…"
if [ -n "$meet" ]; then glyph=$CAMERA; else glyph=$CALENDAR; fi

sketchybar "${args[@]}" --set clock.date drawing=off \
  --set clock.event drawing=on icon="$glyph" icon.color="$color" label="$title  $when" label.color="$color"
