# 🌳 oak

```
   ⚪️🔴  "So! You're setting up a new machine, are you?"

   Every trainer needs a starter kit before heading out.
   This one gets your Mac ready in one run.
```

One script to take a brand-new Mac from zero to a working full-stack dev setup: shell, editor config, Git identities, Neovim, Claude Code, and Codex CLI — all tracked here so the next machine takes minutes, not a weekend.

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

Steps: `clt` (Xcode Command Line Tools — mandatory for `brew`/`git` to work at all; this is the small CLT package, **not** the full Xcode.app — grab that separately from the App Store later if you get into iOS dev), `brew`, `omz` (Oh My Zsh), `symlinks`, `gitdirs`, `ssh`, `github` (auth + push this repo), `mise`, `nvim` (bootstraps LazyVim plugins headlessly), `vscode` (extensions), `orca` (opens the manual download page).

## Starter Kit (what gets installed)

| 🎒 Item | Details |
|---|---|
| Shell | Ghostty (negro puro, Geist Mono, paleta tokyonight) + Oh My Zsh (`robbyrussell` theme), zsh-autosuggestions, zsh-syntax-highlighting |
| Editor | VS Code (settings + curated extensions synced), Orca IDE (manual — no Homebrew cask) |
| Neovim | Neovim + LazyVim-based config, vendored under `nvim/`; plugins bootstrapped on install |
| Runtimes | [mise](https://mise.jdx.dev) — per-project Node/Python/etc. version switching |
| Git | Directory-based identity split: `~/code/side-projects`, `~/code/freelance`, `~/code/{company}` (e.g. `geoactio`) |
| Claude Code | Hooks + statusline, see below |
| Codex CLI | Portable TUI statusline configuration, see below |

## Pokédex (Brewfile contents)

CLI: `git`, `gh`, `mise`, `neovim`, `lazygit`, `jq`, `ripgrep`, `fzf`, `wget`, `tree`
GUI: Chrome, Slack, Raycast, Rectangle
Fonts: `font-geist-mono-nerd-font` (terminal), `font-symbols-only-nerd-font` (glyph fallback)

Deliberately curated, not exhaustive — add more to `Brewfile` as you actually need them.

## Badges (setup checklist, in order)

- [ ] Xcode Command Line Tools
- [ ] Homebrew + `brew bundle`
- [ ] Oh My Zsh
- [ ] Dotfiles symlinked (`.zshrc`, `.gitconfig*`, Ghostty, VS Code, Claude, Neovim)
- [ ] `~/code/side-projects`, `~/code/freelance`, and `~/code/geoactio` created
- [ ] SSH key generated and added to GitHub
- [ ] `gh auth login` + this repo pushed
- [ ] mise global Node/Python defaults
- [ ] Neovim installed + LazyVim plugins bootstrapped
- [ ] VS Code extensions installed
- [ ] Orca IDE installed manually

`install.sh` runs all of these in order and tells you what still needs manual follow-up at the end.

## Git identity split

Repos are grouped by context, not just personal-vs-work:

- `~/code/side-projects/` and `~/code/freelance/` use your personal email (`~/.gitconfig-personal`)
- `~/code/{company}/` (e.g. `~/code/geoactio/`) uses that company's email via its own `~/.gitconfig-{company}` file

Each gets its own `includeIf "gitdir:"` block in `git/.gitconfig`, so no manual `git config user.email` juggling between projects. Starting at a new company: add `~/code/{company}/`, a `git/.gitconfig-{company}` file with that identity, symlink it in `step_symlinks` (`install.sh`), and an `includeIf` block pointing at it.

## Claude Code config

`claude/settings.json` wires up:
- **`hooks/block-coauthor.sh`** — a `PreToolUse` hook on `Bash` that blocks any commit containing `Co-Authored-By`
- **`statusline-command.sh`** — model, context usage, git branch, session time, and rate-limit status in the status line

## Codex CLI config

`codex/config.toml` configures a portable status line with the model and reasoning level, context usage, current directory, Git branch, and five-hour and weekly usage limits. Project trust entries remain local to each machine.

## Neovim

`nvim/` is a LazyVim-based config, vendored directly into this repo (not a submodule) — symlinked to `~/.config/nvim` by `install.sh`.

The `nvim` step runs `nvim --headless "+Lazy! sync" +qa` so the first real `nvim` launch is instant instead of downloading plugins.

### Theming

`nvim/lua/plugins/colorscheme.lua` splits the theme in two on purpose:

- **Chrome** — borders, gutter, statusline, tabs, dashboard, pickers — is forced to a black/white/grey scale via `on_highlights`.
- **Code** — syntax, and diagnostics — keeps tokyonight's palette untouched.

The background is pure `#000000` so Neovim and the terminal are the same colour. `ghostty/config` mirrors it: tokyonight's official ANSI palette (shipped in the plugin's own `extras/ghostty/`) with the background overridden to black, and `window-theme = ghostty` so the titlebar follows suit.

Re-run just this part with `./install.sh --only=nvim`.

## Adding a new machine later

```sh
git clone git@github.com:JuanDls01/oak.git ~/oak && cd ~/oak && ./install.sh
```

That's it — same script, same result, every time.
