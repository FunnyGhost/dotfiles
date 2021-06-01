# Set Variables
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/jdk/Contents/Home'
export ANDROID_HOME=/Users/utukku/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export N_PREFIX="$HOME/.n"


# Change ZSH Options

# Create Aliases
alias exa='exa -laFh --git'
alias ls='exa -laFh --git'
alias bbd='brew bundle dump --force --describe'
alias man=batman
alias trail='<<<${(F)path}'

# SnappCar aliases
alias go2Hell="cd SnappCar\ Projects/frontend-app/"
alias runiOS="ns run ios --device 'iPhone 11 Pro'"
alias listDevices="ns device ios --available-devices"
alias generateTypings='TNS_DEBUG_METADATA_PATH="$(pwd)/metadata" ns build ios && TNS_TYPESCRIPT_DECLARATIONS_PATH="$(pwd)/typings" ns build ios'

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:Library/Python/2.7/bin"
# Add n(node version maneger) to path
export PATH="$PATH:$N_PREFIX/bin"

# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and Other Surprises

###-tns-completion-start-###
if [ -f /Users/utukku/.tnsrc ]; then 
    source /Users/utukku/.tnsrc 
fi
###-tns-completion-end-###
