#!/bin/sh
# Wayfinder's picker: shows the tabs that init.lua collected in fzf and jumps
# to the one you pick. init.lua runs it in a floating pane; see README.md.
#
#   picker.sh <nerd|plain> <tabs>
#     tabs: one line per tab, tab-separated: session id, session, tab id,
#     tab name, agent|term, state, is-current
#
# fzf runs --disabled and this script filters instead, so the list stays
# grouped and a matching session keeps all its tabs. fzf calls back into it:
# --list rebuilds the rows for a query; --focus and --enter keep the cursor
# off session headings. Rows on screen and lines in $WAYFINDER/ids line up,
# so a row's index ({n}) finds its IDs.

tab=$(printf '\t')

is_session_row() {
  line=$(sed -n "$(($1 + 1))p" "$WAYFINDER/ids")
  [ -z "${line#*"$tab"}" ]
}

case "$1" in
  --list) # print the tree for query $2; write the matching IDs
    awk -F'\t' -v q="$2" -v ids="$WAYFINDER/ids" \
      -v agent_icon="$WAYFINDER_AGENT" -v term_icon="$WAYFINDER_TERM" '
      function esc(c) { return "\033[" c "m" }
      function hit(s,   i) { s = tolower(s); for (i = 1; i <= nq; i++) if (!index(s, t[i])) return 0; return 1 }
      function flush(   i) {
        if (!kept) return
        printf "%s %s%s\n", esc("1;35"), slabel, esc(0)
        print sid "\t" > ids
        for (i = 1; i <= kept; i++) {
          printf "  %s%s%s %s %s\n", esc(90), (i == kept ? "└─" : "├─"), esc(0), mark[i], name[i]
          print sid "\t" wid[i] > ids
        }
      }
      BEGIN { nq = split(tolower(q), t, " "); printf "" > ids }
      $1 != sid { flush(); sid = $1; slabel = $2; kept = 0 }
      hit($2 " " $4) {
        kept++; wid[kept] = $3
        name[kept] = ($7 == "1") ? esc("1;32") $4 esc(0) : $4
        mark[kept] = ($6 == "working") ? esc(36) "●" \
                   : ($6 == "blocked") ? esc(31) "●" \
                   : ($6 == "done")    ? esc(32) "●" \
                   : ($6 == "error")   ? esc(91) "✕" \
                   : esc(90) "·"
        mark[kept] = mark[kept] " " (($5 == "agent") ? esc(35) agent_icon : esc(34) term_icon) esc(0) " "
      }
      END { flush() }
    ' "$WAYFINDER/tabs"
    exit 0
    ;;
  --focus) # landed on a session row: keep moving the way the key was going
    [ -n "$2" ] && is_session_row "$2" || exit 0
    if [ "${FZF_POS:-1}" = 1 ]; then echo down
    elif [ "$FZF_POS" = "$FZF_MATCH_COUNT" ]; then echo up
    else
      case "$FZF_KEY" in up | ctrl-p | ctrl-k | btab | scroll-up) echo up ;; *) echo down ;; esac
    fi
    exit 0
    ;;
  --enter) # accept tab rows only
    [ -n "$2" ] && ! is_session_row "$2" && echo "become(echo $2)"
    exit 0
    ;;
esac

if ! command -v fzf >/dev/null 2>&1; then
  echo "Wayfinder needs fzf: https://github.com/junegunn/fzf#installation"
  read -r _
  exit 0
fi

printf '\033]2;Wayfinder\007' # pane title

export WAYFINDER WAYFINDER_AGENT WAYFINDER_TERM
WAYFINDER=$(mktemp -d)
trap 'rm -rf "$WAYFINDER"' EXIT
printf '%s\n' "$2" >"$WAYFINDER/tabs"

if [ "$1" = plain ]; then
  WAYFINDER_AGENT='◆' WAYFINDER_TERM='›'
else # Nerd Font, Material Design: nf-md-robot and nf-md-console
  WAYFINDER_AGENT=$(printf '\363\260\232\251') WAYFINDER_TERM=$(printf '\363\260\206\215')
fi

c() { printf '\033[%sm%s\033[0m' "$1" "$2"; }
legend="$(c 36 ●) running   $(c 31 ●) needs you   $(c 32 ●) done   $(c 90 ·) idle
$(c 35 "$WAYFINDER_AGENT") agent   $(c 34 "$WAYFINDER_TERM") terminal     $(c 90 '↑↓ move · ⏎ jump · esc close')"

self=$0
n=$(sh "$self" --list '' | fzf --ansi --disabled --no-sort --layout=reverse \
  --no-mouse --info=hidden --gutter=' ' --no-scrollbar \
  --prompt='  ' --pointer='▌' --padding=1,2 \
  --ghost='where to?' \
  --footer="$legend" \
  --color='bg+:-1,fg+:-1:bold,hl:-1,hl+:-1:bold' \
  --color='prompt:6,pointer:2,ghost:8,footer:8,separator:8,border:8' \
  --bind "change:reload(sh '$self' --list {q})" \
  --bind 'load:pos(2)' \
  --bind "focus:transform(sh '$self' --focus {n})" \
  --bind "enter:transform(sh '$self' --enter {n})")
[ -n "$n" ] || exit 0

line=$(sed -n "$((n + 1))p" "$WAYFINDER/ids")
"${REX_BIN_DIR:+$REX_BIN_DIR/}rex" do session.select \
  session_id="${line%%"$tab"*}" window_id="${line#*"$tab"}" >/dev/null

exit 0 # always succeed: Rex keeps a pane open after a quick failure (Esc)
