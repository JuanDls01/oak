export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git macos fzf)
source "$ZSH/oh-my-zsh.sh"

# Homebrew
if [[ -d /opt/homebrew/bin ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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
