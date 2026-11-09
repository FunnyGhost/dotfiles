#!/bin/bash

# Sourced by the Rex scripts. sketchybar's PATH doesn't include rex, which
# lives inside the Rex app bundle. --autostart=false: the bar must never start
# a Rex server; when Rex isn't running, calls just fail.

REX_BIN="$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"
command -v rex >/dev/null && REX_BIN=$(command -v rex)

rex() { "$REX_BIN" --autostart=false "$@"; }
