# Set Variables
export HOMEBREW_CASK_OPTS="--no-quarantine"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export ANDROID_HOME=/Users/utukku/Library/Android/sdk

# Change ZSH Options

# Create Aliases
alias exa='exa -laFh --git'
alias ls='exa -laFh --git'
alias man=batman
alias go2Hell="cd SnappCar\ Projects/frontend-app/"
alias runiOS="ns run ios --device 'iPhone 11 Pro'"
alias listDevices="ns device ios --available-devices"

# Customize Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:Library/Python/2.7/bin"

# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and Other Surprises
