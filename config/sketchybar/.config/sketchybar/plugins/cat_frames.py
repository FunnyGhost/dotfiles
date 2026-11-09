#!/usr/bin/env python3
# Draws the running cat's frames as PNGs, standard library only.
# cat_frames.py <out dir> [pixels per cell]
# Writes cat_1..4.png. A calico (brown, white and black), running right, with a
# dark outline added around it so it reads on any wallpaper.

import os
import struct
import sys
import zlib

out = sys.argv[1]
scale = int(sys.argv[2]) if len(sys.argv) > 2 else 2  # 2 = one cell per point on Retina

PALETTE = {
    "b": 0xFF9C6B3F,  # brown
    "d": 0xFF6E4627,  # dark brown, for shading
    "w": 0xFFF4F1EA,  # white
    "k": 0xFF1B1B20,  # black
    "e": 0xFFB5E05A,  # eye
    "p": 0xFFEFA0AE,  # nose and inner ear
}
OUTLINE = 0xE6101119

# 30 wide: tail up at the back (black tip), brown and black patches on a
# white body, round brown-capped head with one black ear, white muzzle
BODY = [
    ".....................b....k...",
    ".kk.................bpb..kpk..",
    "kkk.................bbbbbbkkk.",
    ".kb.................bbbbbbkkkk",
    "..bb................bbbbebkkkk",
    "..db....wwbbbbbkkkkkbbbwwwwwww",
    "...bb.wwwbbbbbbdkkkkbwwwwwwwwp",
    "....bwwwwwbbbbbddkkkkwwwwwwww.",
    "....wwwwwwwbbbbbbkkkwwwwwww...",
    "....wwwwwwwwbbbbbwwwwwwwwww...",
    "....wwwwwwwwwwwwwwwwwwwwwww...",
    ".....wwwwwwwwwwwwwwwwwwwwww...",
]
LEGS = [  # a four-step gallop: stretched, passing, gathered, passing
    [
        "....ww..ww.........ww..ww.....",
        "...ww....ww.......ww....ww....",
        "..ww......ww.....ww......ww...",
    ],
    [
        ".....ww.ww..........ww.ww.....",
        ".....ww..ww.........ww..ww....",
        "......ww..ww.........ww..ww...",
    ],
    [
        ".......wwww..........wwww.....",
        "........ww............ww......",
        "........ww............ww......",
    ],
    [
        ".....ww.ww.........ww.ww......",
        "....ww..ww........ww..ww......",
        "....ww..ww........ww..ww......",
    ],
]
assert all(len(r) == 30 for r in BODY + sum(LEGS, []))


def rgba(v):
    return bytes(((v >> 16) & 255, (v >> 8) & 255, v & 255, (v >> 24) & 255))


def outlined(rows):
    # pad by one cell, then outline every empty cell touching the cat
    w = len(rows[0]) + 2
    grid = ["." * w] + ["." + r + "." for r in rows] + ["." * w]
    res = []
    for y, r in enumerate(grid):
        line = []
        for x, ch in enumerate(r):
            if ch == ".":
                near = any(
                    0 <= y + dy < len(grid) and 0 <= x + dx < w and grid[y + dy][x + dx] != "."
                    for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1))
                )
                line.append(OUTLINE if near else None)
            else:
                line.append(PALETTE[ch])
        res.append(line)
    return res


def png(path, cells):
    blank = bytes(4)
    raw = b""
    for r in cells:
        line = b"".join((rgba(c) if c is not None else blank) * scale for c in r)
        raw += (b"\0" + line) * scale

    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))

    w, h = len(cells[0]) * scale, len(cells) * scale
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)))
        f.write(chunk(b"IDAT", zlib.compress(raw)))
        f.write(chunk(b"IEND", b""))


os.makedirs(out, exist_ok=True)
for n, legs in enumerate(LEGS, 1):
    png(f"{out}/cat_{n}.png", outlined(BODY + legs))
