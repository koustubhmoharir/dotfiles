# This controls the default time style in the output of ls
export TIME_STYLE=long-iso

# This improves tab completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'        #\e[Z is the code for Shift + Tab

#This disables the ability to suspend the terminal with Ctrl + S and unfreeze it with Ctrl + Q
stty -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=5000
export HISTSIZE=${HISTFILESIZE}

set_histfile_by_dir() {
    case "$PWD" in
        "$HOME/projects/"*)
            # First path component after ~/projects/
            project="${PWD#"$HOME/projects/"}"
            project="${project%%/*}"

            # Safety: only allow simple names in filename
            project="${project//[^A-Za-z0-9._-]/_}"

            export HISTFILE="$HOME/.bash_history_projects_${project}"
            ;;
        *)
            export HISTFILE="$HOME/.bash_history"
            ;;
    esac
}

export PROMPT_COMMAND="history -a; set_histfile_by_dir; history -c; history -r${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -n "$ZELLIJ" ]; then
    # Minimal prompt inside Zellij
    PS1='${debian_chroot:+($debian_chroot)}\$ '
elif [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Helper function to add a directory to PATH safely
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Add your folders safely
add_to_path "/usr/lib/go-1.26/bin"
add_to_path "$HOME/go/bin"
add_to_path "$HOME/.local/bin"

# Remove the function so it stays clean
unset -f add_to_path

# enable fzf key bindings
source /usr/share/doc/fzf/examples/key-bindings.bash

parent_cmd=$(ps -o comm= -p "$PPID" 2>/dev/null)

if command -v zellij >/dev/null 2>&1 \
   && [ -z "$ZELLIJ" ] \
   && [ -n "$KONSOLE_VERSION" ] \
   && [ "$TERM_PROGRAM" != "vscode" ] \
   && [ "$parent_cmd" = "konsole" ]; then
    eval "$(zellij setup --generate-auto-start bash)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

cc_start_session_log() {
    local dir="$HOME/termsessions"
    mkdir -p "$dir"

    local timestamp
    timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"

    local raw="$dir/$timestamp.raw"
    local log="$dir/$timestamp.log"

    script -qef "$raw"
    col -b < "$raw" | ansifilter > "$log"

    echo
    echo "Raw:  $raw"
    echo "Text: $log"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

