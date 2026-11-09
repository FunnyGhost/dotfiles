#!/bin/bash

# Coding agents running in Rex tabs, from the status their panes report to Rex
# (OSC 7501). Bar: the robot, coloured by the most urgent state, and a count
# per state. Popup: grouped by session like Wayfinder (rex/wayfinder), most
# urgent session and tab first; clicking a tab jumps to it. No agents hides
# the item.
#
# Same rules as Wayfinder: a tab is an agent when a tiled pane reports a status,
# the most urgent pane wins, and an unnamed tab shows its terminal title.

source "$CONFIG_DIR/theme.sh"
source "$CONFIG_DIR/plugins/rex_cmd.sh"

case "$SENDER" in
  mouse.clicked) sketchybar --set agents popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set agents popup.drawing=off; exit 0 ;;
esac


# One line per agent tab: rank<TAB>session<TAB>tab<TAB>state<TAB>session id<TAB>window id
# rank sorts by urgency: needs you, failed, busy, your turn
rows=$(
  rex ls --json 2>/dev/null | jq -r '.sessions[] | [.session_id, .label] | @tsv' |
    while IFS=$'\t' read -r sid session; do
      rex window ls -s "$sid" --json 2>/dev/null | jq -r '.windows[] | [.window_id, .label, .focused_block_id,
          ([.layers[] | select(.kind == "tiled") | .blocks[].block_id] | join(" "))] | @tsv' |
        while IFS=$'\t' read -r wid tab focused panes; do
          best=""
          for bid in $panes; do
            # -s is required: without it, blocks outside the default session aren't found
            line=$(rex block call -s "$sid" -b "$bid" program_status 2>/dev/null | jq -r '
              .records[]? | select(.id == null and .state != "idle")
              | [({blocked: 1, error: 2, working: 3, done: 4}[.state] // 5), .state] | @tsv')
            if [ -n "$line" ] && { [ -z "$best" ] || [ "${line%%$'\t'*}" -lt "${best%%$'\t'*}" ]; }; then
              best=$line
            fi
          done
          [ -n "$best" ] || continue
          if [[ $tab =~ ^Window\ [0-9a-f]{8}$ ]]; then
            title=$(rex block call -s "$sid" -b "$focused" title 2>/dev/null | jq -r '.title // empty')
            tab=${title:-$tab}
          fi
          IFS=$'\t' read -r rank state <<<"$best"
          printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$rank" "$session" "$tab" "$state" "$sid" "$wid"
        done
    done |
    # most urgent first, then each session's tabs gathered under its first row
    sort -t$'\t' -k1,1n -k2,2 -k3,3 |
    awk -F'\t' '!($2 in seen) { seen[$2]; order[++n] = $2 } { rows[$2] = rows[$2] $0 "\n" }
      END { for (i = 1; i <= n; i++) printf "%s", rows[order[i]] }'
)

count() { printf '%s\n' "$rows" | cut -f4 | grep -cx "$1"; }
blocked=$(count blocked)
errors=$(count error)
finished=$(count done)
working=$(count working)

args=(--remove '/agentpop\.row\..*/')

if [ $((blocked + errors + finished + working)) -eq 0 ]; then
  sketchybar "${args[@]}" --set agents drawing=off popup.drawing=off \
    --set '/agents\..*/' drawing=off
  exit 0
fi

color=$GREEN
[ "$working" -gt 0 ] && color=$CYAN
[ $((blocked + errors)) -gt 0 ] && color=$RED

show() { if [ "$2" -gt 0 ]; then echo "drawing=on icon=$2"; else echo "drawing=off"; fi; }

i=0
last=""
while IFS=$'\t' read -r _ session tab state sid wid; do
  [ -n "$state" ] || continue
  if [ "$session" != "$last" ]; then
    args+=(--add item "agentpop.row.$i" popup.agents
      --set "agentpop.row.$i" "${row[@]}" icon.drawing=off label="$session" label.color="$PURPLE"
      label.font="$FONT:Bold:12.0" label.padding_left=12 label.padding_right=12)
    i=$((i + 1))
    last=$session
  fi
  case "$state" in
    blocked | error) dot=$RED ;;
    done) dot=$GREEN ;;
    *) dot=$CYAN ;;
  esac
  args+=(--add item "agentpop.row.$i" popup.agents
    --set "agentpop.row.$i" "${row[@]}" icon="●" icon.color="$dot" icon.font="$FONT:Regular:9.0"
    icon.padding_left=26 icon.padding_right=6
    click_script="$CONFIG_DIR/plugins/rex_jump.sh $sid $wid"
    label="$tab" label.color="$TEXT" label.font="$FONT:Regular:12.0" label.padding_right=12)
  i=$((i + 1))
done <<<"$rows"
args+=(--add item agentpop.row.pad popup.agents --set agentpop.row.pad "${popup_pad[@]}")

# shellcheck disable=SC2046 # show() emits several key=value words on purpose
sketchybar "${args[@]}" --set agents drawing=on icon.color="$color" --set agents.end drawing=on \
  --set agents.blocked $(show blocked "$blocked") \
  --set agents.error $(show error "$errors") \
  --set agents.done $(show done "$finished") \
  --set agents.working $(show working "$working")
