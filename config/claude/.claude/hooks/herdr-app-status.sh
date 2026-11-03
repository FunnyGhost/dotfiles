#!/bin/sh
# Report Claude Code's state to Herdr.app (herdr-core) via OSC 7501.
# The app lists a terminal as an agent only once its program reports a
# status, and Claude Code doesn't emit OSC 7501 itself.
#
# Usage: herdr-app-status.sh <idle|working|done|blocked[:kind=...]|clear>

cat >/dev/null # drain the hook's JSON input

[ -n "${HC_TERMINAL_ID:-}" ] || exit 0 # not inside Herdr.app
[ -n "${1:-}" ] || exit 0

# Hooks have no controlling terminal (/dev/tty fails), so walk up to the
# nearest ancestor that has one — the claude process — and write there.
pid=$$
while [ "$pid" -gt 1 ]; do
  tty=$(ps -o tty= -p "$pid" | tr -d ' ')
  case "$tty" in
    '' | '??') pid=$(ps -o ppid= -p "$pid" | tr -d ' ') ;;
    *) break ;;
  esac
done
case "$tty" in '' | '??') exit 0 ;; esac

printf '\033]7501;state=%s:app=claude-code\007' "$1" >"/dev/$tty" 2>/dev/null || true
