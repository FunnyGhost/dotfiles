#!/usr/bin/env bash
# Claude Code statusline. Reads session JSON on stdin, prints a single line.
# Format: <model> │ $<cost> │ <ctx>% ctx │ <cwd>
set -euo pipefail

input=$(cat)

model=$(jq -r '.model.display_name // "claude"' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
ctx=$(jq -r '(.context_window.used_percentage // 0) | round' <<<"$input")
cwd=$(jq -r '.workspace.current_dir // "?"' <<<"$input")
cwd_short=${cwd/#$HOME/\~}

printf '%s │ $%.2f │ %s%% ctx │ %s' "$model" "$cost" "$ctx" "$cwd_short"
