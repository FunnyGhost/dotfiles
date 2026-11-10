#!/bin/bash

# Long-running: the cat's behaviour. Its mood follows the CPU, sampled every
# 5s: under 15% it idles (sits and blinks, grooms, yawns, naps), then walks,
# runs from 50% and sprints from 80%. Idle frames change every few seconds at
# most, so a resting cat costs very little. Started (and restarted on reload)
# by sketchybarrc; ends when sketchybar quits. Frames come from cat_frames.py,
# redrawn into ~/.cache whenever it changes.

FRAMES="$HOME/.cache/sketchybar/cat"
if [ ! -f "$FRAMES/cat_sit.png" ] || [ "$CONFIG_DIR/plugins/cat_frames.py" -nt "$FRAMES/cat_sit.png" ]; then
  /bin/rm -f "$FRAMES"/cat_*.png # frames that were renamed shouldn't linger
  # 3px per cell: 1.5pt on Retina, about 48x26pt on the bar
  python3 -I "$CONFIG_DIR/plugins/cat_frames.py" "$FRAMES" 3 || exit 1
fi

cores=$(sysctl -n hw.ncpu)

# Mood levels: 0 idle, 1 walk, 2 run, 3 sprint. Going up needs 15/50/80% CPU,
# coming down needs it under 10/40/70%, so a load hovering at a threshold
# doesn't make the cat flip between moods
level=0
update_level() {
  local cpu up=0 down=0
  cpu=$(ps -A -o %cpu= | awk -v n="$cores" '{ s += $1 } END { printf "%d", s / n }')
  [ "$cpu" -ge 15 ] && up=1
  [ "$cpu" -ge 50 ] && up=2
  [ "$cpu" -ge 80 ] && up=3
  [ "$cpu" -ge 10 ] && down=1
  [ "$cpu" -ge 40 ] && down=2
  [ "$cpu" -ge 70 ] && down=3
  if [ "$up" -gt "$level" ]; then
    level=$up
  elif [ "$down" -lt "$level" ]; then
    level=$down
  fi
}

# The plan: a queue of frame:tenths-of-a-second steps, refilled when empty
plan=()
napping=0
queue() { plan+=("$@"); }

idle_plan() {
  local i n r=$((RANDOM % 100))
  if [ "$r" -lt 40 ]; then # sit: blink now and then, sometimes flick the tail
    n=$((RANDOM % 3 + 2))
    for ((i = 0; i < n; i++)); do queue "sit:$((RANDOM % 40 + 20))" blink:2; done
    [ $((RANDOM % 2)) -eq 0 ] && queue flick:6 sit:4 flick:6
  elif [ "$r" -lt 65 ]; then # groom
    queue sit:10
    n=$((RANDOM % 5 + 5))
    for ((i = 0; i < n; i++)); do queue groom_1:4 groom_2:4; done
    queue sit:10
  elif [ "$r" -lt 80 ]; then # yawn
    queue sit:10 yawn:12 sit:20 blink:2
  else # nap for one to three minutes, then stretch and yawn awake
    napping=1
    n=$((RANDOM % 30 + 15))
    for ((i = 0; i < n; i++)); do queue sleep_1:15 sleep_2:15 sleep_3:15; done
    queue stretch:25 yawn:12 sit:20
  fi
}

move_plan() {
  case "$level" in
    1) queue run_2:4 run_4:4 ;;                     # walk
    2) queue run_1:2 run_2:2 run_3:2 run_4:2 ;;     # run
    *) queue run_1:1 run_2:1 run_3:1 run_4:1 ;;     # sprint
  esac
}

next_sample=0
shown=""
while :; do
  if [ "$SECONDS" -ge "$next_sample" ]; then
    pgrep -qx sketchybar || exit 0
    was=$level
    update_level
    next_sample=$((SECONDS + 5))
    if [ "$level" != "$was" ]; then
      plan=() # react now, not after the current plan
      # woken by work: stretch first
      [ "$napping" = 1 ] && [ "$level" -gt 0 ] && queue stretch:15
      napping=0
    fi
  fi

  if [ ${#plan[@]} -eq 0 ]; then
    napping=0
    if [ "$level" -eq 0 ]; then idle_plan; else move_plan; fi
  fi
  step=${plan[0]}
  plan=("${plan[@]:1}")
  frame=${step%%:*}
  tenths=${step#*:}

  # a frame that's already showing needs no redraw
  if [ "$frame" != "$shown" ]; then
    sketchybar --set cat icon.background.image="$FRAMES/cat_$frame.png" 2>/dev/null
    shown=$frame
  fi
  sleep "$((tenths / 10)).$((tenths % 10))"
done
