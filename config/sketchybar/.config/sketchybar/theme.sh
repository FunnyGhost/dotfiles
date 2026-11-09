#!/bin/bash

# Sourced by sketchybarrc and the plugins: the Eldritch palette, the font, and
# the shared pill and popup styles. Change the look here, not per item.

FONT="Hack Nerd Font"

# Eldritch
TEXT=0xffebfafa
DIM=0xff7081d0
PURPLE=0xffa48cf2
CYAN=0xff04d1f9
GREEN=0xff37f499
YELLOW=0xfff1fc79
ORANGE=0xfff7c67f
RED=0xfff16c75
CLEAR=0x00000000

PILL_BG=0xcc212337
POPUP_BG=0xf2212337

# A bracket's background: a rounded island around its items
pill=(
  background.color=$PILL_BG
  background.corner_radius=9
  background.height=28
  background.border_width=1
  background.border_color=0x22ffffff
)

popup=(
  popup.align=left
  popup.y_offset=6
  popup.height=10
  popup.background.color=$POPUP_BG
  popup.background.corner_radius=10
  popup.background.border_width=1
  popup.background.border_color=0x33a48cf2
  popup.background.shadow.drawing=on
)
# Popup rows are 24pt via a transparent background. popup.height is only the
# minimum, kept low so popup_pad can be a short spacer at the bottom.
row=(background.drawing=on background.color=$CLEAR background.height=24)
popup_pad=(icon.drawing=off label.drawing=off background.drawing=on
  background.color=$CLEAR background.height=10)
popup_header=(
  "${row[@]}"
  icon.drawing=off
  label.font="$FONT:Bold:10.0"
  label.color=$DIM
  label.padding_left=12
  label.padding_right=12
)

# A value: bright number (icon), dim word (label), one size so they share a
# baseline
value=(
  padding_left=0
  padding_right=4
  icon.font="$FONT:Bold:13.0"
  icon.padding_right=5
  label.font="$FONT:Regular:13.0"
  label.color=$DIM
  label.padding_left=0
)
