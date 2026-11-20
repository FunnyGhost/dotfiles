#!/usr/bin/env python3
# Asks Codex itself for the plan's rate limits, the numbers its apps show,
# which count use from every app, not only what's logged on this Mac.
# Talks to `codex app-server` (Codex's own JSON-RPC interface) over stdio:
# initialize, then account/rateLimits/read, then stop. Codex handles the
# login; nothing here touches its credentials, and only read-only requests
# are sent.
# Prints: 5h used %<TAB>5h reset epoch<TAB>week used %<TAB>week reset epoch
# Exits 1 if Codex isn't installed, logged out, offline, or slow (15s), after
# one retry.

import json
import shutil
import subprocess
import sys
import threading

codex = shutil.which("codex") or "/opt/homebrew/bin/codex"


def read_limits():
    try:
        proc = subprocess.Popen(
            [codex, "app-server"], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL, text=True,
        )
    except OSError:
        sys.exit(1)
    timer = threading.Timer(15, proc.kill)  # never hang the bar
    timer.daemon = True
    timer.start()
    for msg in (
        {"id": 0, "method": "initialize", "params": {"clientInfo": {"name": "sketchybar", "version": "1.0"}}},
        {"method": "initialized"},
        {"id": 1, "method": "account/rateLimits/read"},
    ):
        proc.stdin.write(json.dumps(msg) + "\n")
    proc.stdin.flush()
    limits = None
    for line in proc.stdout:
        try:
            msg = json.loads(line)
        except ValueError:
            continue
        if msg.get("id") == 1:
            limits = (msg.get("result") or {}).get("rateLimits")
            break
    proc.kill()
    windows = [(limits or {}).get(k) for k in ("primary", "secondary")]
    return windows if all(windows) else None


# OpenAI's usage endpoint answers 503 now and then: try twice
windows = read_limits() or read_limits()
if not windows:
    sys.exit(1)
print("\t".join(str(w.get(k) or 0) for w in windows for k in ("usedPercent", "resetsAt")))
