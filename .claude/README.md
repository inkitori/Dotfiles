# Claude Context (local-only)

This directory holds Claude Code memory and chat transcripts so a future Claude
session started from `~/dotfiles/` can pick up where this one left off.

**This directory is gitignored.** It contains potentially sensitive
conversation content; nothing here gets pushed.

## Layout

```
.claude/
├── README.md          (this file — git-tracked)
├── memory/            structured notes Claude wrote about you, the project,
│                      and your preferences. Loaded automatically by Claude.
├── transcripts/       raw .jsonl conversation logs + tool-result cache.
│                      Mostly for your own reference / grep.
└── sync.sh            re-copies the latest memory + transcripts from
                       ~/.claude/projects/<current-cwd>/ into here.
```

## How session continuation works

Claude Code keys sessions by the directory you launched it in. So:

- Sessions started from `~/.config/nvim/` live at
  `~/.claude/projects/-Users-enyouki--config-nvim/`.
- Sessions started from `~/dotfiles/` live at
  `~/.claude/projects/-Users-enyouki-dotfiles/`.

To continue **this** conversation in `~/dotfiles/`:

```sh
cd ~/dotfiles
claude --continue
```

Setup that's already in place:

- `~/.claude/projects/-Users-enyouki-dotfiles/<session>.jsonl` — copied from
  the original session so `claude --continue` can resume it.
- `~/.claude/projects/-Users-enyouki-dotfiles/memory/` — symlinked to
  `~/dotfiles/.claude/memory/` so memory stays in one canonical place.

## Refreshing the snapshot

The transcripts here are a snapshot from the moment this dir was created. To
refresh from a still-running session in another working directory, run
`./sync.sh` and pass the source project dir:

```sh
./sync.sh ~/.claude/projects/-Users-enyouki--config-nvim
```

## Manually editing memory

Memory files are plain markdown with frontmatter. You can edit them directly:

- `memory/MEMORY.md` — the index. Each line points to a memory file.
- `memory/<name>.md` — individual memory entries with frontmatter.

Future Claude sessions will read whatever's in there.
