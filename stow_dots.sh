#!/bin/bash
cd "$(dirname "$0")"
stow -t ~ */

LINE='[ -f ~/.custom.bashrc ] && . ~/.custom.bashrc'
grep -qxF "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc

