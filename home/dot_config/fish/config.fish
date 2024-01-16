# Source first thing to load the PATH
set -x CUSTOM_SHELL_DIR "$HOME/.local/share/shell"
source "$CUSTOM_SHELL_DIR/variables.fish"

starship init fish | source

source "$CUSTOM_SHELL_DIR/alias.fish"
source "$CUSTOM_SHELL_DIR/functions.fish"

function fish_greeting
    fortune -s | xargs -0 cowsay
end

if status --is-interactive;
    source "$CUSTOM_SHELL_DIR/interactive.fish"
end
