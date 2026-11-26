#!/bin/bash

# Bluetooth headphones, for the sound item (plugins/volume.sh). Its popup
# lists every paired headphone or headset, in a fixed name order; click one
# to connect or disconnect it. Then Bluetooth and Sound settings.
#   bluetooth.sh scan               note what's connected (every 30s, on wake)
#   bluetooth.sh popup              that, plus fill in the popup's rows
#   bluetooth.sh toggle ADDR STATE N  click on popup row N
# "What's connected" goes to a cache file as that pair's icon (earbuds or
# headphones, empty for none), which volume.sh shows instead of the speaker.
# A connection only counts once it holds: AirPods often link for a moment and
# drop again. system_profiler lists the devices; blueutil connects them, so
# the first click makes macOS ask whether sketchybar may use Bluetooth.

source "$CONFIG_DIR/theme.sh"

# Nerd Font glyphs as escaped bytes: tools drop them as literal characters
BT_OFF=$(printf '\363\260\202\262')     # md-bluetooth_off
HEADPHONES=$(printf '\363\260\213\213') # md-headphones
EARBUDS=$(printf '\363\261\241\217')    # md-earbuds
COG=$(printf '\363\260\222\223')        # md-cog

CACHE="$HOME/.cache/sketchybar"
CONNECTED="$CACHE/bt_connected"
BUSY="$CACHE/bluetooth.busy"
SELF="'$CONFIG_DIR/plugins/bluetooth.sh'"
VOLUME="'$CONFIG_DIR/plugins/volume.sh'"
mkdir -p "$CACHE"

# Bluetooth power (on/off), then one line per headphone, sorted by name so a
# pair keeps its place in the list when it connects:
#   connected|paired<TAB>address<TAB>name<TAB>earbuds|headphones
# Earbuds (AirPods, AirPods Pro…) report a charging case and left/right
# serial numbers; over-ear ones like AirPods Max don't.
scan() {
  system_profiler SPBluetoothDataType -json 2>/dev/null | jq -r '.SPBluetoothDataType[0] |
    (if .controller_properties.controller_state == "attrib_on" then "on" else "off" end),
    ((.device_connected // [] | map(to_entries[] | ["connected", .key, .value]))
      + (.device_not_connected // [] | map(to_entries[] | ["paired", .key, .value]))
    | map(select(.[2].device_minorType == "Headphones" or .[2].device_minorType == "Headset")
      | [.[0], .[2].device_address, (.[1] | sub(" - Find My$"; "")),
         (if .[2].device_caseVersion or .[2].device_serialNumberLeft then "earbuds" else "headphones" end)])
    | sort_by(.[2] | ascii_downcase) | .[] | @tsv)'
}

glyph_for() { if [ "$1" = earbuds ]; then echo "$EARBUDS"; else echo "$HEADPHONES"; fi; }

# The connected pair's icon, for volume.sh to show
note_connected() {
  local kind
  kind=$(grep '^connected' <<<"$2" | head -1 | cut -f4)
  if [ "$1" = on ] && [ -n "$kind" ]; then glyph_for "$kind" >"$CONNECTED"; else : >"$CONNECTED"; fi
}

popup() {
  local power=$1 devices=$2 i=0 args=() state addr name kind glyph color n click
  # Same devices as last time (the usual case after a click): update the rows
  # in place. Removing and re-adding items while the popup is open left them
  # undrawn, so the list went blank after a connect. Rows: one per device,
  # then Bluetooth and Sound settings.
  local shown count
  shown=$(sketchybar --query volume | jq -r '[.popup.items[] | select(test("^btpop\\.row\\.[0-9]+$"))] | length')
  count=$(grep -c . <<<"$devices")
  if [ "$power" = on ] && [ "$count" -gt 0 ] && [ "$shown" = $((count + 2)) ]; then
    while IFS=$'\t' read -r state addr name kind; do
      if [ "$state" = connected ]; then color=$GREEN; else color=$DIM; fi
      glyph=$(glyph_for "$kind") click="$SELF toggle $addr $state $i"
      args+=(--set "btpop.row.$i" icon="$glyph" icon.color="$color" label="$name" click_script="$click"
        --set "btpop.row.$i.s" icon="$glyph" label="" label.color=$DIM click_script="$click")
      i=$((i + 1))
    done <<<"$devices"
    sketchybar "${args[@]}"
    return
  fi

  args=(--remove '/btpop\.row\..*/')
  add_row() { args+=(--add item "btpop.row.$i" popup.volume --set "btpop.row.$i" "${row[@]}"
    icon.padding_left=12 label.padding_right=12 label.font="$FONT:Regular:12.0" "$@"); i=$((i + 1)); }

  if [ "$power" = off ]; then
    add_row icon="$BT_OFF" icon.color=$DIM label="Turn Bluetooth on" \
      click_script="blueutil --power 1; $SELF popup; SENDER=refresh NAME=volume $VOLUME"
  elif [ -z "$devices" ]; then
    add_row icon.drawing=off label="No paired headphones" label.color=$DIM
  else
    while IFS=$'\t' read -r state addr name kind; do
      if [ "$state" = connected ]; then color=$GREEN; else color=$DIM; fi
      glyph=$(glyph_for "$kind") n=$i click="$SELF toggle $addr $state $i"
      add_row icon="$glyph" icon.color="$color" label="$name" background.height=18 click_script="$click"
      # Its subtitle, btpop.row.N.s: always there, empty until a click, so
      # "connecting…" moves nothing. The invisible icon lines it up under the name.
      args+=(--add item "btpop.row.$n.s" popup.volume --set "btpop.row.$n.s" "${row[@]}"
        background.height=12 icon="$glyph" icon.color=$CLEAR icon.padding_left=12
        label="" label.font="$FONT:Regular:10.0" label.color=$DIM label.padding_right=12
        label.y_offset=1 click_script="$click")
    done <<<"$devices"
  fi
  add_row icon="$COG" icon.color=$DIM label="Bluetooth settings…" label.color=$DIM \
    click_script="open 'x-apple.systempreferences:com.apple.BluetoothSettings'; sketchybar --set volume popup.drawing=off"
  add_row icon="$COG" icon.color=$DIM label="Sound settings…" label.color=$DIM \
    click_script="open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'; sketchybar --set volume popup.drawing=off"
  args+=(--add item btpop.row.pad popup.volume --set btpop.row.pad "${popup_pad[@]}")
  sketchybar "${args[@]}"
  # rows added to an open popup only draw once it reopens
  if [ "$(sketchybar --query volume | jq -r .popup.drawing)" = on ]; then
    sketchybar --set volume popup.drawing=off && sketchybar --set volume popup.drawing=on
  fi
}

# a change in progress; older than a minute means its script died: ignore it
busy() { [ -f "$BUSY" ] && [ $(($(date +%s) - $(stat -f %m "$BUSY"))) -lt 60 ]; }

# Is ADDR connected right now? (system_profiler: 0.1s, blueutil takes 2s)
is_connected() { scan | grep -q "^connected"$'\t'"$1"$'\t'; }

case "$1" in
  scan)
    busy && exit 0 # the change in progress refreshes everything when done
    { read -r power; devices=$(cat); } < <(scan)
    note_connected "$power" "$devices"
    ;;
  popup)
    { read -r power; devices=$(cat); } < <(scan)
    busy || note_connected "$power" "$devices"
    popup "$power" "$devices"
    ;;
  toggle)
    addr=$2 item="btpop.row.$4"
    # one change at a time
    busy && exit 0
    echo "$addr" >"$BUSY"
    trap '/bin/rm -f "$BUSY"' EXIT

    if [ "$3" = connected ]; then want=0 verb=disconnect doing="disconnecting…"; else want=1 verb=connect doing="connecting…"; fi
    sketchybar --set "$item" icon.color=$YELLOW --set "$item.s" label="$doing" label.color=$YELLOW \
      --set volume icon="$(sketchybar --query "$item" | jq -r .icon.value)" icon.color=$YELLOW
    blueutil "--$verb" "$addr" >/dev/null 2>&1

    # Watch the real state for up to 15s. Connected counts after 3 checks in
    # a row (a link that comes up and drops is the flaky case), gone after 2.
    need=$((want == 1 ? 3 : 2)) streak=0
    for _ in $(seq 15); do
      if is_connected "$addr"; then now=1; else now=0; fi
      if [ "$now" = "$want" ]; then streak=$((streak + 1)); else streak=0; fi
      [ "$streak" -ge "$need" ] && break
      sleep 1
    done
    if [ "$streak" -lt "$need" ]; then
      sketchybar --set "$item" icon.color=$RED --set "$item.s" label="couldn't $verb" label.color=$RED
      sleep 3
    fi

    { read -r power; devices=$(cat); } < <(scan)
    note_connected "$power" "$devices"
    popup "$power" "$devices"
    # done: the sound item's icon follows (the pair, or back to the speaker);
    # the marker goes first, or volume.sh would leave the progress icon
    /bin/rm -f "$BUSY"
    NAME=volume SENDER=refresh CONFIG_DIR="$CONFIG_DIR" "$CONFIG_DIR/plugins/volume.sh"
    ;;
esac
