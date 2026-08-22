#!/usr/bin/env bash
# oak — one-shot dev environment bootstrap for a new Mac.
#
# Usage:
#   ./install.sh                     run everything
#   ./install.sh --list              show available steps and exit
#   ./install.sh --only=brew,omz     run only these steps
#   ./install.sh --skip=vscode,orca  run everything except these steps
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_USER="JuanDls01"
REPO_NAME="oak"
PERSONAL_EMAIL="juanignaciodelossantos01@gmail.com"

log()  { printf '\n\033[1;32m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$1"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "oak is macOS-only." >&2
  exit 1
fi

# ── Step selection ────────────────────────────────────────────────────────
ALL_STEPS=(clt brew omz symlinks gitdirs ssh github mise vscode orca)
ONLY=""
SKIP=""

for arg in "$@"; do
  case "$arg" in
    --list)
      printf 'Available steps:\n'
      for s in "${ALL_STEPS[@]}"; do printf '  %s\n' "$s"; done
      exit 0
      ;;
    --only=*)  ONLY="${arg#--only=}" ;;
    --skip=*)  SKIP="${arg#--skip=}" ;;
    *)
      echo "Unknown argument: $arg (use --only=, --skip=, or --list)" >&2
      exit 1
      ;;
  esac
done

should_run() {
  local step="$1"
  if [[ -n "$ONLY" ]]; then
    [[ ",$ONLY," == *",$step,"* ]]
    return
  fi
  if [[ -n "$SKIP" ]]; then
    [[ ",$SKIP," != *",$step,"* ]]
    return
  fi
  return 0
}

# ── Steps ──────────────────────────────────────────────────────────────────

step_clt() {
  log "Checking Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then
    log "Already installed"
    return
  fi

  # `xcode-select --install` pops a separate GUI dialog that can silently
  # fail to render. Installing straight through softwareupdate is more
  # reliable for an unattended/scripted setup.
  warn "Not found — installing via softwareupdate (this can take a few minutes)"
  local label
  label=$(softwareupdate --list 2>/dev/null | grep -o 'Command Line Tools for Xcode[^"]*' | sort -V | tail -1)

  if [[ -n "$label" ]]; then
    softwareupdate --install "$label"
  else
    warn "Couldn't find a Command Line Tools label via softwareupdate — falling back to the GUI trigger. Watch for a system dialog (check other Spaces/displays if it doesn't appear up front)."
    xcode-select --install >/dev/null 2>&1 || true
    until xcode-select -p >/dev/null 2>&1; do
      sleep 5
    done
  fi

  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools installed"
  else
    warn "Still not detected — you may need to finish this manually, then re-run with --skip=clt"
  fi
}

step_brew() {
  log "Checking Homebrew"
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  log "Running brew bundle"
  brew bundle --file="$DOTFILES_DIR/Brewfile"
}

step_omz() {
  log "Checking Oh My Zsh"
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    log "Already installed"
  fi
}

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.bak.$(date +%s)"
    warn "Backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  log "Linked $dest -> $src"
}

step_symlinks() {
  link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
  link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  link "$DOTFILES_DIR/git/.gitconfig-personal" "$HOME/.gitconfig-personal"
  link "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"
  link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
  link "$DOTFILES_DIR/claude/hooks/block-coauthor.sh" "$HOME/.claude/hooks/block-coauthor.sh"
  link "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
  chmod +x "$HOME/.claude/hooks/block-coauthor.sh" "$HOME/.claude/statusline-command.sh"

  local vscode_user_dir="$HOME/Library/Application Support/Code/User"
  link "$DOTFILES_DIR/vscode/settings.json" "$vscode_user_dir/settings.json"

  link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
}

step_gitdirs() {
  mkdir -p "$HOME/code/personal" "$HOME/code/work"
  log "Created ~/code/personal and ~/code/work (personal vs. work git identity split)"
}

step_ssh() {
  local ssh_key="$HOME/.ssh/id_ed25519"
  if [[ ! -f "$ssh_key" ]]; then
    log "Generating SSH key"
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$PERSONAL_EMAIL" -f "$ssh_key" -N ""
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add --apple-use-keychain "$ssh_key"
    cat <<KEYMSG

  >>> Add this SSH key to GitHub: https://github.com/settings/keys

$(cat "$ssh_key.pub")

KEYMSG
    read -r -p "Press Enter once you've added the key to GitHub to continue... "
  else
    log "SSH key already exists at $ssh_key"
  fi
}

step_github() {
  log "Checking gh auth"
  if ! gh auth status >/dev/null 2>&1; then
    gh auth login
  fi

  cd "$DOTFILES_DIR"
  if [[ ! -d .git ]]; then
    git init
    git add -A
    git commit -m "Initial oak setup"
  fi

  if ! git remote get-url origin >/dev/null 2>&1; then
    gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin --push
  else
    git push -u origin HEAD
  fi
}

step_mise() {
  log "Setting mise global defaults (Node LTS, latest Python)"
  eval "$(mise activate bash)"
  mise use --global node@lts python@latest
}

step_vscode() {
  if command -v code >/dev/null 2>&1; then
    log "Installing VS Code extensions"
    while IFS= read -r ext; do
      [[ -z "$ext" || "$ext" == \#* ]] && continue
      code --install-extension "$ext" --force
    done < "$DOTFILES_DIR/vscode/extensions.txt"
  else
    warn "VS Code 'code' CLI not found on PATH. Open VS Code, run 'Shell Command: Install code command in PATH' from the command palette, then re-run this script (or just: ./install.sh --only=vscode)."
  fi
}

step_orca() {
  warn "Orca IDE has no Homebrew cask — opening its download page"
  open "https://www.onorca.dev/download/started?platform=macos-arm64" 2>/dev/null || true
}

# ── Run ────────────────────────────────────────────────────────────────────
for step in "${ALL_STEPS[@]}"; do
  if should_run "$step"; then
    "step_$step"
  fi
done

log "Done."
cat <<SUMMARY
  - Restart your terminal (or open Ghostty) to pick up the new .zshrc
  - Repo: https://github.com/$GITHUB_USER/$REPO_NAME
SUMMARY
