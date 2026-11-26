#!/bin/bash

# A click on the sound popup's slider: sets the volume (and unmutes), then
# refreshes the sound item.

osascript -e "set volume output volume $PERCENTAGE" -e 'set volume without output muted'

NAME=volume SENDER=refresh "$CONFIG_DIR/plugins/volume.sh"
