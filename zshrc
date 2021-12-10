
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
# [ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
# Set Variables
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
export ANDROID_HOME=/Users/cthulhu/Library/Android/sdk
export N_PREFIX="$HOME/.n"

# Change ZSH Options

# Create Aliases
alias exa='exa -laFh --git'
alias ls='exa -laFh --git'
alias bbd='brew bundle dump --force --describe'
alias man=batman
alias trail='<<<${(F)path}'
alias rm=trash
alias go2Personal=" cd Sandbox\ Projects/keepadoo-monorepo/"

# SnappCar aliases
alias go2Work="cd SnappCar\ Projects/frontend-app/"
alias runiOS="ns run ios --device 'iPhone 11 Pro'"
alias listDevices="ns device ios --available-devices"
alias generateTypings='TNS_DEBUG_METADATA_PATH="$(pwd)/metadata" ns build ios && TNS_TYPESCRIPT_DECLARATIONS_PATH="$(pwd)/typings" ns build ios'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to $path array Variable
typeset -U path

path=(
    "$N_PREFIX/bin"
    $path
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin:Library/Python/2.7/bin"
    "$ANDROID_HOME/platform-tools"
    "Library/Python/2.7/bin"
)

# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and Other Surprises

###-tns-completion-start-###
if [ -f /Users/cthulhu/.tnsrc ]; then
    source /Users/cthulhu/.tnsrc
fi
###-tns-completion-end-###

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
# [ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
export GPG_TTY=$(tty)

###-tns-completion-start-###
if [ -f /Users/cthulhu/.tnsrc ]; then
    source /Users/cthulhu/.tnsrc
fi
###-tns-completion-end-###
