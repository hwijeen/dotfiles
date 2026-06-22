#!/usr/bin/env bash
set -euxo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
