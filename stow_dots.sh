#!/bin/bash
cd "$(dirname "$0")"
mkdir -p ~/.local/bin
mkdir -p ~/.config/lazygit
mkdir -p ~/.config/yazi
stow -t ~ */

LINE='[ -f ~/.custom.bashrc ] && . ~/.custom.bashrc'
grep -qxF "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc

