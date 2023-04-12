#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo -e "\\n⬇️  Set up Homebrew and install almost everything"

if test ! "$(brew --version)"
  then
  echo -e "\\n⬇️  Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo -e "\\n⭐️ Installed Homebrew! Close all terminal sessions and run this script again."
  exit
else
  echo -e "\\n🔁 Homebrew is installed! Updating instead."
  brew update
  brew upgrade
fi

echo -e "\\n⬇️  Installing Homebrew formulae"
# install via brew
brew bundle --file=./Brewfile
