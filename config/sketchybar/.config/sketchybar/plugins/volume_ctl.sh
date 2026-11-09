#!/bin/bash

# Clicks in the volume popup: the slider sets the volume (and unmutes), the
# mute row toggles mute. Then refreshes the volume item.

case "$NAME" in
  volpop.slider)
    osascript -e "set volume output volume $PERCENTAGE" -e 'set volume without output muted'
    ;;
  volpop.mute)
    osascript -e 'set volume output muted not (output muted of (get volume settings))'
    ;;
esac

NAME=volume SENDER=refresh "$CONFIG_DIR/plugins/volume.sh"
