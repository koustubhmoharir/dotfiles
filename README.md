# Instructions for setup
Install stow if it is not available.

Run stow_dots.sh to stow into your home directory.

## List of useful packages
stow fzf ripgrep fd-find ansifilter git-delta meld podman podman-compose
Ubuntu: vim-gtk3
Fedora: vim-x11  gawk keychain
To set umask on fedora in WSL, sudoedit /etc/profile.d/umask.sh, and enter `umask 0002` in it.

Many useful tools need to be installed from pre-built binaries

## zellij:
sudo curl -fsSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz \
    | tar -C /usr/local/bin -xz
sudo chmod +x /usr/local/bin/zellij

## yazi:
cd /tmp \
    && wget "https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-x86_64-unknown-linux-gnu.zip"
unzip yazi-x86_64-unknown-linux-gnu.zip
sudo install -m755 yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/yazi
sudo install -m755 yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/ya
rm -rf /tmp/yazi-x86_64-unknown-linux-gnu*
ya pkg add dedukun/relative-motions
ya pkg add melindachang/kanagawa-paper

## lazygit:
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin/
rm lazygit lazygit.tar.gz

## zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

## To load ssh keys automatically
Add the following to ~/.bashrc (specify list of keys to be loaded)
if [[ $- == *i* ]]; then
    eval $(keychain --eval --quiet id_ed25519 id_rsa)
fi
