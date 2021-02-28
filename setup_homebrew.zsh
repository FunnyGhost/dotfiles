#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# TODO: Keep an eye out for a different `--no-quarantine` solution
# Currently, you can't do `brew bundle --no-quarantine` as an option.
# It's currently exported in zhrc:
# export HOMEBREW_CASK_OPTS="--no-quarantine"

brew bundle --verbose