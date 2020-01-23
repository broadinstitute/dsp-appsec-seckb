#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

setup() {
  # Export this ENV var in your .bashrc or .zshrc
  export GPG_TTY=$(tty)

  git config --global gpg.program `which gpg`
  git config --global commit.gpgsign true
}

generate_key() {
  cat >.gpgconfig <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: 1
     Key-Length: 2048
     Subkey-Type: 1
     Subkey-Length: 2048
     Name-Real: `git config --get user.name`
     Name-Email: `git config --get user.email`
     Expire-Date: `date -v +30d "+%Y-%m-%d"`
     %commit
     %echo done
EOF
  gpg --batch --gen-key .gpgconfig
  rm .gpgconfig
}

export_key() {
  signingkey=$(gpg --list-secret-keys --keyid-format LONG "`git config --get user.email`" | grep sec | awk '{print $2}' | awk -F'/' '{print $2}' | tail -n 1)
  git config --global user.signingkey $signingkey
}

restart_agent() {
  # The agent will restart automatically at the first usage
  gpgconf --kill gpg-agent
}

github_setup() {
  gpg --armor --export `git config --get user.signingkey` | pbcopy
  open https://github.com/settings/keys

  echo ""
  echo ""
  echo ""
  echo "=== GitHub setup"
  echo ""
  echo "  1. Click on New GPG key"
  echo "  2. Paste the clipboard contents"
  echo "  3. Click on Add GPG key"
  echo "  4. Type your password (if asked)"
}

main() {
  setup
  generate_key
  export_key
  restart_agent
  github_setup
}

main
