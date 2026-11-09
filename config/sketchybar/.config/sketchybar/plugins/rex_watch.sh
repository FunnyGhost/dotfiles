#!/bin/bash

# Long-running: turns Rex agent-status changes into sketchybar's
# rex_agents_change event, so the agents item updates without polling.
# Started (and restarted on reload) by sketchybarrc.

source "$CONFIG_DIR/plugins/rex_cmd.sh"

while :; do
  rex events --all --json 2>/dev/null |
    grep --line-buffered '"name":"program_status_' |
    while read -r _; do
      # Claude reports on every tool call; fold a burst into one update
      while read -r -t 1 _; do :; done
      sketchybar --trigger rex_agents_change
    done
  sleep 10 # Rex isn't running or restarted; try again
done
