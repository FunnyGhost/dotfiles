# 🔎 wwid — *What Was I Doing*

> find & resume Claude Code chats from anywhere

`wwid` indexes every Claude Code conversation on this machine and lets you
fuzzy-search them by name, PR, project, or first prompt — then re-opens the one
you pick with `claude --resume`, in its original folder.

It is **read-only** by default — it only reads Claude's transcript files under
`~/.claude/projects/` — with one opt-in exception, `wwid --rename`, which names
un-named chats (and backs them up first). See *Renaming* below.

## 📦 What's in here

```
config/wwid/
├── README.md            ← you are here (not stowed)
└── .local/
    └── bin/
        └── wwid       ← the tool, stowed to ~/.local/bin/wwid
```

This is a [GNU Stow](https://www.gnu.org/software/stow/) package, like the rest
of `config/`. Stowing it symlinks `~/.local/bin/wwid` →
`~/dotfiles/config/wwid/.local/bin/wwid`. (Stow ignores top-level
`README.*` by default, so this file is never symlinked into `~`.)

## 🚀 Setup

**On a fresh machine** there's nothing extra to do: the dotfiles setup already
runs `stow -d config -t ~ $(command ls config)` (see the repo `CLAUDE.md`
§1.3), which picks up this package automatically, and `~/.local/bin` is added
to `PATH` by the stowed `config/zsh/.zshrc`.

**To link it manually** (e.g. right after adding it):

```bash
cd ~/dotfiles
stow -d config -t ~ wwid
```

### Requirements

| Tool      | Why                                   | Install              |
|-----------|---------------------------------------|----------------------|
| `python3` | runs the script (stdlib only)         | preinstalled / brew  |
| `fzf`     | the interactive picker                | `brew install fzf`   |
| `claude`  | resume target + `--rename` titles     | Claude Code          |

All three are already in the repo's `Brewfile` / setup, so a stowed machine has
them.

### Verify

```bash
readlink ~/.local/bin/wwid   # → .../dotfiles/config/wwid/.local/bin/wwid
wwid list | head             # prints a table of your chats
```

## 🧭 Usage

```bash
wwid                 # fuzzy picker over all chats; Enter resumes the one you pick
wwid <query>         # same picker, pre-filtered by <query>
wwid pr <num|url>    # find chat(s) linked to a PR; resume if there's exactly one
wwid list            # plain text table (good for scripts / grep)
wwid --rename        # name every chat you never named, from its content
wwid -h | --help     # usage
```

### Renaming un-named chats (`wwid --rename`)

`wwid` is read-only **except** for this one command. It gives a short
(4–5 word) content-based name to every chat you never named yourself:

- **Skips** any chat that already has a `/rename` name, and any chat that's
  currently running.
- Generates each title with a cheap, side-effect-free `claude -p` call
  (Haiku, no saved session, no MCP, no tools).
- Writes the name by appending a `custom-title` record — exactly what
  `/rename` does — so it sticks and shows in Claude's `/resume` picker too.
- **Backs up** every file it touches to `~/.claude/.wwid-rename-backup-<ts>/`
  before writing, and asks for confirmation first.

```bash
wwid --rename --dry-run   # preview the new names, write nothing
wwid --rename             # do it (prompts before writing)
wwid --rename --yes       # do it without the confirmation prompt
```

To undo: restore the matching files from the backup folder (the title is the
last line of each touched transcript).

### In the picker

- **Type** to fuzzy-filter across every visible column **and** the (hidden)
  full first prompt.
- **Enter** resumes the highlighted chat — `wwid` `cd`s into the chat's
  original folder, then hands off to `claude --resume <id>`.
- **Esc** cancels without doing anything.

### Columns

| Column         | Meaning                                                        |
|----------------|----------------------------------------------------------------|
| `NAME`         | your `/rename` name → else the auto AI title → else 1st prompt  |
| `AGE`          | time since the chat was last active                            |
| `CTX`          | approx % of the context window used at the last turn           |
| `MSGS`         | total user + assistant messages                                |
| `PR`           | pull request(s) linked to the chat (auto-linked on `gh pr create`) |
| `PROJECT`      | the folder the chat ran in                                     |
| `FIRST PROMPT` | the first meaningful thing you typed                           |

## 🛠️ How it works

Claude Code stores each conversation as a `.jsonl` file (one JSON record per
line) under `~/.claude/projects/<encoded-folder>/<session-id>.jsonl`. `wwid`
reads a few record types from each file:

| Record `type`  | Used for                          |
|----------------|-----------------------------------|
| `custom-title` | your manually set name            |
| `ai-title`     | the auto-generated name           |
| `pr-link`      | linked PR number / URL / repo     |
| `user`         | the first real prompt + cwd       |
| `assistant`    | message count + token usage (CTX) |

A full scan of all transcripts takes a fraction of a second, so `wwid` reads
them live on every run — no cache or index file to maintain.

The script itself is heavily commented; open
`.local/bin/wwid` to read how each piece works.

## ✏️ Editing

Because `~/.local/bin/wwid` is a symlink into this repo, just edit
`.local/bin/wwid` here and the change is live immediately — no re-stow needed
(re-stow is only needed when **adding** new files to the package).
