# 🌳 oak

```
   ⚪️🔴  "So! You're setting up a new machine, are you?"

   Every trainer needs a starter kit before heading out.
   This one gets your Mac ready in one run.
```

One script to take a brand-new Mac from zero to a working full-stack dev setup: shell, editor config, Git identities, Neovim, and Claude Code — all tracked here so the next machine takes minutes, not a weekend.

## Quickstart

```sh
git clone git@github.com:JuanDls01/oak.git ~/oak
cd ~/oak
./install.sh
```

The script is interactive at a couple of points (the Xcode Command Line Tools GUI installer, adding your SSH key to GitHub, `gh auth login`) — it'll pause and tell you what to do.

**Before your first push from a fresh machine**, check `git/.gitconfig` — the name/email in there should be yours.

### Running only part of it

`install.sh` is split into named steps you can pick and choose:

```sh
./install.sh --list              # show step names
./install.sh --only=brew,omz     # run just these
./install.sh --skip=vscode,orca  # run everything except these
```

Steps: `clt` (Xcode Command Line Tools — mandatory for `brew`/`git` to work at all; this is the small CLT package, **not** the full Xcode.app — grab that separately from the App Store later if you get into iOS dev), `brew`, `omz` (Oh My Zsh), `symlinks`, `gitdirs`, `ssh`, `github` (auth + push this repo), `mise`, `vscode` (extensions), `orca` (opens the manual download page).

## Starter Kit (what gets installed)

| 🎒 Item | Details |
|---|---|
| Shell | Ghostty + Oh My Zsh (`robbyrussell` theme), zsh-autosuggestions, zsh-syntax-highlighting |
| Editor | VS Code (settings + curated extensions synced), Orca IDE (manual — no Homebrew cask) |
| Neovim | LazyVim-based config, vendored under `nvim/` |
| Runtimes | [mise](https://mise.jdx.dev) — per-project Node/Python/etc. version switching |
| Git | Directory-based identity split: `~/code/personal` vs `~/code/work` |
| Claude Code | Hooks + statusline, see below |

## Pokédex (Brewfile contents)

CLI: `git`, `gh`, `mise`, `jq`, `ripgrep`, `fzf`, `wget`, `tree`
GUI: Chrome, Slack, Raycast, Rectangle

Deliberately curated, not exhaustive — add more to `Brewfile` as you actually need them.

## Badges (setup checklist, in order)

- [ ] Xcode Command Line Tools
- [ ] Homebrew + `brew bundle`
- [ ] Oh My Zsh
- [ ] Dotfiles symlinked (`.zshrc`, `.gitconfig*`, Ghostty, VS Code, Claude, Neovim)
- [ ] `~/code/personal` and `~/code/work` created
- [ ] SSH key generated and added to GitHub
- [ ] `gh auth login` + this repo pushed
- [ ] mise global Node/Python defaults
- [ ] VS Code extensions installed
- [ ] Orca IDE installed manually

`install.sh` runs all of these in order and tells you what still needs manual follow-up at the end.

## Git identity split

Any repo cloned under `~/code/personal/` uses your personal email; anything under `~/code/work/` uses your company email — set via `includeIf "gitdir:"` in `git/.gitconfig`. No manual `git config user.email` juggling between projects.

## Claude Code config

`claude/settings.json` wires up:
- **`hooks/block-coauthor.sh`** — a `PreToolUse` hook on `Bash` that blocks any commit containing `Co-Authored-By`
- **`statusline-command.sh`** — model, context usage, git branch, session time, and rate-limit status in the status line

## Neovim

`nvim/` is a LazyVim-based config, vendored directly into this repo (not a submodule) — symlinked to `~/.config/nvim` by `install.sh`.

## Adding a new machine later

```sh
git clone git@github.com:JuanDls01/oak.git ~/oak && cd ~/oak && ./install.sh
```

That's it — same script, same result, every time.
