#!/usr/bin/env bash

setup_git_secrets() {
    # Install git-secrets
    brew install git-secrets

    # Enable on all repos
    git secrets --install ~/.git-secrets -f
    git config --global core.hooksPath ~/.git-secrets/hooks -f

    # For AWS; git secrets has a function just to do that
    git secrets --register-aws --global
    # Regex 16-digit-string wrapped with double quotes
    git secrets --add --global '"[A-Za-z0-9/\+=]{16}"'
    # Literal 'private_key'
    git secrets --add --global 'private_key'
    git secrets --add --global 'private_key_id'
    # Literal 'client_email'; gcp related
    git secrets --add --global --literal 'client_email'
    # Literal 'client_id'; gcp related
    git secrets --add --global --literal 'client_id'
    # Literal 'notification_token'
    git secrets --add --global --literal 'notification_token'
    # Literal 'cromwell_password'
    git secrets --add --global --literal 'cromwell_password'
}


setup_git_secrets