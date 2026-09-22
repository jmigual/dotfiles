# Source first thing to load the PATH
set -x CUSTOM_SHELL_DIR "$HOME/.local/share/shell"

starship init fish | source

source "$CUSTOM_SHELL_DIR/alias.fish"
source "$CUSTOM_SHELL_DIR/functions.fish"

function fish_greeting
    if command -vq fortune; and command -vq cowsay
        fortune -s | xargs -0 cowsay
    end
end

if status --is-interactive;
    source "$CUSTOM_SHELL_DIR/interactive.fish"
end

