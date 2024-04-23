#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed using "n", which is in the Brewfile
# See zshrc for N_PREFIX variable addition to $path array.

if exists node; then
  echo "Node $(node --version) & NPM $(npm --version) already installed"
else
  echo "Installing Node & NPM with n..."
  n lts
fi


# Install npm packages
npm config set save-exact true -g
npm install --global @angular/cli
npm install --global typescript
npm install --global trash-cli

echo "Global npm packages installed:"
npm list --global --depth=0
