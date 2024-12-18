#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/bjw-s-labs/dotfiles"

function get_os_type() {
  uname
}

declare ostype="$(get_os_type)"
if [ "${ostype}" == "Darwin" ]; then
  # Install XCode Command Line Tools if necessary
  declare git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"
  if [ ! -e "${git_cmd_path}" ]; then
    xcode-select --install
  else
    echo "Command line developer tools are already installed."
  fi

  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if which -s brew; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Install chezmoi if necessary
  if which -s chezmoi; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi

  # Install 1Password if necessary
  if which -s op; then
    echo "1Password is already installed."
  else
    brew install --cask 1password
    brew install 1password-cli
    read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
  fi

  # Apply dotfiles
  echo "Applying Chezmoi configuration."
  chezmoi init bjw-s-labs/dotfiles
  chezmoi apply
fi
