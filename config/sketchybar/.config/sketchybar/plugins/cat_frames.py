#!/usr/bin/env python3
# Draws the cat's frames as PNGs, standard library only.
# cat_frames.py <out dir> [pixels per cell]
# Writes cat_<name>.png for every frame below. A calico (brown, white and
# black) facing right, with a dark outline added around it so it reads on any
# wallpaper. plugins/cat.sh decides which frame shows when.

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
    "p": 0xFFEFA0AE,  # nose, inner ear, tongue
    "z": 0xFF9AA5CE,  # the sleeping Z
}
OUTLINE = 0xE6101119

# Every frame is 30x15 cells, so poses swap without the cat jumping around
FRAMES = {
    "run_1": [  # gallop: stretched
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
        "....ww..ww.........ww..ww.....",
        "...ww....ww.......ww....ww....",
        "..ww......ww.....ww......ww...",
    ],
    "run_2": [  # passing (walk uses 2 and 4)
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
        ".....ww.ww..........ww.ww.....",
        ".....ww..ww.........ww..ww....",
        "......ww..ww.........ww..ww...",
    ],
    "run_3": [  # gathered
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
        ".......wwww..........wwww.....",
        "........ww............ww......",
        "........ww............ww......",
    ],
    "run_4": [  # passing
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
        ".....ww.ww.........ww.ww......",
        "....ww..ww........ww..ww......",
        "....ww..ww........ww..ww......",
    ],
    "sit": [
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "..............bbbbebkkkk......",
        "...........bb.bbbwwwwwww......",
        "..........bbbbbwwwwwwwwp......",
        ".........bbbbkkwwwwwww........",
        "........bbbbbkkwwwww..........",
        "........dbbbbkkwwwww..........",
        ".......wdbbbkwwwwwww..........",
        ".......wwbbbwwww.ww...........",
        ".......wwwwwwwww.ww...........",
        ".k.....wwwwwwwww.ww...........",
        ".kkbbbbbwwwwwww..wwww.........",
    ],
    "blink": [
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "..............bbbbbbkkkk......",
        "...........bb.bbbwwwwwww......",
        "..........bbbbbwwwwwwwwp......",
        ".........bbbbkkwwwwwww........",
        "........bbbbbkkwwwww..........",
        "........dbbbbkkwwwww..........",
        ".......wdbbbkwwwwwww..........",
        ".......wwbbbwwww.ww...........",
        ".......wwwwwwwww.ww...........",
        ".k.....wwwwwwwww.ww...........",
        ".kkbbbbbwwwwwww..wwww.........",
    ],
    "flick": [  # tail up
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "..............bbbbebkkkk......",
        "...........bb.bbbwwwwwww......",
        "..........bbbbbwwwwwwwwp......",
        ".........bbbbkkwwwwwww........",
        ".k......bbbbbkkwwwww..........",
        ".kk.....dbbbbkkwwwww..........",
        "..b....wdbbbkwwwwwww..........",
        "..b....wwbbbwwww.ww...........",
        "..bb...wwwwwwwww.ww...........",
        "...bb..wwwwwwwww.ww...........",
        "....bbbbwwwwwww..wwww.........",
    ],
    "groom_1": [  # paw to the face
        "..............................",
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "...........bb.bbbbbbkkkk......",
        "..........bbbbbbbwwwwwwwww....",
        ".........bbbbkbwwwwwwwwpww....",
        "........bbbbbkkwwwwwwwww......",
        "........dbbbbkkwwwwww.........",
        ".......wdbbbkwwwwwww..........",
        ".......wwbbbwwww...ww.........",
        ".......wwwwwwwww...ww.........",
        ".k.....wwwwwwwww...ww.........",
        ".kkbbbbbwwwwwww...www.........",
    ],
    "groom_2": [  # licking
        "..............................",
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "...........bb.bbbbbbkkkk......",
        "..........bbbbbbbwwwwwww......",
        ".........bbbbkbwwwwwwwwppw....",
        "........bbbbbkkwwwwwwwwwww....",
        "........dbbbbkkwwwwww.........",
        ".......wdbbbkwwwwwww..........",
        ".......wwbbbwwww...ww.........",
        ".......wwwwwwwww...ww.........",
        ".k.....wwwwwwwww...ww.........",
        ".kkbbbbbwwwwwww...www.........",
    ],
    "yawn": [
        "...............b....k.........",
        "..............bpb..kpk........",
        "..............bbbbbbkkk.......",
        "..............bbbbbbkkkk......",
        "..............bbbbbbkkkk......",
        "...........bb.bbbwwwwkppp.....",
        "..........bbbbbwwwwwwwkpp.....",
        ".........bbbbkkwwwwwwwwww.....",
        "........bbbbbkkwwwww..........",
        "........dbbbbkkwwwww..........",
        ".......wdbbbkwwwwwww..........",
        ".......wwbbbwwww.ww...........",
        ".......wwwwwwwww.ww...........",
        ".k.....wwwwwwwww.ww...........",
        ".kkbbbbbwwwwwww..wwww.........",
    ],
    "stretch": [  # play bow, after waking
        ".kk...........................",
        "..kb..........................",
        "...b..........................",
        "....bb........................",
        ".....bbbbb....................",
        ".....bbbbbbkk.................",
        ".....wbbbbbbkkkk.....b....k...",
        ".....wwbbbbbbkkkkb..bpb..kpk..",
        ".....wwwbbbbbbkkbbbbbbbbbbkkk.",
        ".....wwwwwbbbbbbbbbbbbbbbbkkkk",
        ".....ww.wwwwwwwwwwbbbbbbebkkkk",
        ".....ww.ww.wwwwwwwwwbbbwwwwwww",
        ".....ww.ww..........bwwwwwwwwp",
        ".....ww.ww...........wwwwwww..",
        "....www.www.....wwwwwwwwwwwwww",
    ],
    "sleep_1": [  # curled up
        "..............................",
        "..............................",
        "..............................",
        "..............................",
        "..............................",
        "..............................",
        ".................b....k.......",
        "................bpb..kpk......",
        ".........bbbbbb.bbbbbbkkk.....",
        ".......bbbbbbkkdbbbbbbkkkk....",
        "......bbbbbkkkkdbbbddbkkkk....",
        ".....wbbbbbkkkdbbbwwwwwww.....",
        ".....wwwwwwwwwwwwwwwwwwwp.....",
        ".....wwwwwwwwwwwwwwwwwww......",
        "...kkbbbbbbbbbbbbbbbbb........",
    ],
    "sleep_2": [  # breathing in, a Z
        "..............................",
        "..............................",
        "........................zzzzz.",
        "...........................z..",
        "..........................z...",
        ".........................z....",
        ".................b....k.zzzzz.",
        ".........bbbbbb.bpb..kpk......",
        ".........bbbbbb.bbbbbbkkk.....",
        ".......bbbbbbkkdbbbbbbkkkk....",
        "......bbbbbkkkkdbbbddbkkkk....",
        ".....wbbbbbkkkdbbbwwwwwww.....",
        ".....wwwwwwwwwwwwwwwwwwwp.....",
        ".....wwwwwwwwwwwwwwwwwww......",
        "...kkbbbbbbbbbbbbbbbbb........",
    ],
    "sleep_3": [  # the Z floats up
        ".........................zzzzz",
        "............................z.",
        "...........................z..",
        "..........................z...",
        ".........................zzzzz",
        "..............................",
        ".................b....k.......",
        ".........bbbbbb.bpb..kpk......",
        ".........bbbbbb.bbbbbbkkk.....",
        ".......bbbbbbkkdbbbbbbkkkk....",
        "......bbbbbkkkkdbbbddbkkkk....",
        ".....wbbbbbkkkdbbbwwwwwww.....",
        ".....wwwwwwwwwwwwwwwwwwwp.....",
        ".....wwwwwwwwwwwwwwwwwww......",
        "...kkbbbbbbbbbbbbbbbbb........",
    ],
}
assert all(len(f) == 15 and all(len(r) == 30 for r in f) for f in FRAMES.values())


def rgba(v):
    return bytes(((v >> 16) & 255, (v >> 8) & 255, v & 255, (v >> 24) & 255))


def outlined(rows):
    # pad by one cell, then outline every empty cell touching the drawing
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
for name, rows in FRAMES.items():
    png(f"{out}/cat_{name}.png", outlined(rows))
