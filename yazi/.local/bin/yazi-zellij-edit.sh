#!/usr/bin/env bash
set -euo pipefail

editor="${EDITOR:-vim}"
editor="${editor%% *}"

# Outside Zellij: normal editing behavior.
if [[ -z "${ZELLIJ:-}" ]]; then
    exec "$editor" "$@"
fi

(( $# > 0 )) || exit 0

# Use absolute paths, since the editor may have a different cwd.
files=()
for file in "$@"; do
    if [[ "$file" = /* ]]; then
        files+=("$file")
    else
        files+=("$PWD/$file")
    fi
done

# Identify the current tab using the Yazi pane.
panes=$(zellij action list-panes --json)
tab=$(jq -r --argjson id "${ZELLIJ_PANE_ID}" '
    .[] | select(.id == $id and .is_plugin == false)
    | .tab_id
' <<< "$panes")

if [[ -z "$tab" ]]; then
    echo "Could not identify current Zellij tab" >&2
    exit 1
fi

# Extract candidate editor panes in this tab.
candidates=$(jq -c --argjson tab "$tab" '
    [.[] |
      select(.tab_id == $tab and .is_plugin == false)
      | select(.exited == false)
      | select((.title // "") | test("^yazi-edit(-[0-9]+)?$"))
    ]
' <<< "$panes")

# Reuse the first pane whose running command is Vim or Neovim.
target=$(jq -r '
    sort_by(
      if .title == "yazi-edit" then 0
      else (.title | capture("-(?<n>[0-9]+)$").n | tonumber)
      end
    )
    | .[]
    | select(
        (.terminal_command // .pane_command // "")
        | test("(^|/)(n?vim)( |$)")
      )
    | .id
' <<< "$candidates" | head -n 1)

if [[ -n "$target" ]]; then
    # Construct a safely escaped Vim filename argument.
    # fnameescape() handles spaces and Ex special characters.
    args=()
    for file in "${files[@]}"; do
        # Escape for a Vim single-quoted string.
        escaped=${file//\'/\'\'}
        args+=("'$escaped'")
    done

    # Use :execute to evaluate fnameescape() in Vim.
    expr=""
    for arg in "${args[@]}"; do
        [[ -n "$expr" ]] && expr+=" . ' ' . "
        expr+="fnameescape($arg)"
    done

    # :drop switches to an existing buffer or opens the file.
    command="execute 'drop ' . $expr"

    zellij action send-keys --pane-id "$target" "Esc"
    zellij action write-chars --pane-id "$target" ":$command"
    zellij action send-keys --pane-id "$target" "Enter"

    zellij action focus-pane-id "terminal_$target"
    exit 0
fi

# No reusable editor. Choose an unused pane name.
name="yazi-edit"

if jq -e 'any(.[]; .title == "yazi-edit")' \
    <<< "$candidates" >/dev/null; then
    n=1
    while jq -e --arg name "yazi-edit-$n" \
        'any(.[]; .title == $name)' \
        <<< "$candidates" >/dev/null; do
        ((n += 1))
    done
    name="yazi-edit-$n"
fi

# Create an editor pane below Yazi.
zellij action new-pane \
    --direction down \
    --name "$name" \
    --cwd "$PWD" \
    --close-on-exit \
    -- "$editor" "${files[@]}"

