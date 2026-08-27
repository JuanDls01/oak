export ZSH="$HOME/.oh-my-zsh"
# Prompt propio (definido más abajo), no un tema de oh-my-zsh.
ZSH_THEME=""
plugins=(git macos fzf)
source "$ZSH/oh-my-zsh.sh"

# Homebrew
if [[ -d /opt/homebrew/bin ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Prompt ──────────────────────────────────────────────────
# Starship (config: ~/.config/starship.toml) — estilo Pure: dos
# líneas, ruta en azul, rama de git en verde, estado en amarillo.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# mise - per-project Node/Python/etc versions
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# zsh-autosuggestions (installed via Homebrew, see ../Brewfile)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aliases
alias ll="ls -lah"
alias gs="git status"
alias gc="git commit"
alias gp="git push"

# zsh-syntax-highlighting must be sourced last
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
