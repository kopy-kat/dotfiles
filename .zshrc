# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="refined"
plugins=(git git-open zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search vi-mode)
source $ZSH/oh-my-zsh.sh

# Aliases
alias lg="lazygit"

alias ft="forge test"
alias fb="forge build"

alias pt="pnpm test"
alias pd="pnpm dev"
alias pb="pnpm build"

alias bt="bun run test"
alias bd="bun run dev"
alias bb="bun run build"


alias gm="foundryup"

alias vim="nvim"

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --all"
alias lsg="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --all --grid"

alias x="exit"

alias ghrel='gh release create $1 --generate-notes --target main'

alias gclone='function _gclone() {
    local url="$1"
    local name="${2:-$(basename "$url" .git)}"
    git clone "$url" "$name" && cd "$name"
}; _gclone'

alias opr='op run --env-file=".env" --'

# Paths

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Foundry
export PATH="$PATH:$HOME/.foundry/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(fzf --zsh)"

eval "$(zoxide init zsh)"
alias cd="z"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export FORCE_COLOR=true
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
