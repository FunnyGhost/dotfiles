# ------------- Variables -------------
# Set XDG paths (used by many modern apps)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export N_PREFIX="$HOME/.n"
export EDITOR='nvim'
# Add Locations to $path array Variable
typeset -U path

path=(
    "$N_PREFIX/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    $path
    "Library/Python/2.7/bin"
    "$HOME/.git-commands"
)

# ------------- Functions -------------
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
export DYLD_LIBRARY_PATH="/opt/homebrew/lib/"

# ------------- Aliases -------------
alias ls='eza -a --long --git --hyperlink --icons=always'
alias lt='eza --tree --level=2 --long --icons --git'
alias cd='z'
alias bbd='brew bundle dump --force --describe && [[ -f Brewfile.local ]] && brew bundle dump --force --describe --file=Brewfile.local'
alias man=batman
alias trail='<<<${(F)path}'
alias rm=trash
alias inv='nvim $(fzf --preview="bat {}")'

# ------------- Prompt -------------
# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# starship
eval "$(starship init zsh)"

# -------------- FZF --------------
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
# Eldritch theme
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
# ------------- Other stuff -------------
# direnv setup 👇
eval "$(direnv hook zsh)"
# zoxide setup 👇
eval "$(zoxide init zsh)"

# Added by Windsurf
export PATH="/Users/cthulhu/.codeium/windsurf/bin:$PATH"

# ------------- VI Mode Configuration -------------
# Enable VI mode
bindkey -v

# Reduce the delay when switching modes (default is 0.4 seconds)
export KEYTIMEOUT=1

# Allow backspace to cross line boundaries
bindkey -v '^?' backward-delete-char

# Allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Allow ctrl-p and ctrl-n for history navigation
bindkey '^p' up-history
bindkey '^n' down-history

# ------------- Local/Work Configuration -------------
# Source work-specific secrets and configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
