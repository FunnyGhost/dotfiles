# ------------- Variables -------------
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
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin:Library/Python/2.7/bin"
    "Library/Python/2.7/bin"
    "$HOME/.git-commands"
    "$HOME/dotfiles/git-commands"
    "$HOME/.tmux/plugins/tmuxifier/bin"
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
alias ls='eza --long --git --hyperlink --icons=always --no-filesize --no-time --no-permissions --no-user'
alias bbd='brew bundle dump --force --describe'
alias man=batman
alias trail='<<<${(F)path}'
alias rm=trash

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

# ------------- Other stuff -------------
# direnv setup 👇
eval "$(direnv hook zsh)"
# zoxide setup 👇
eval "$(zoxide init zsh)"
