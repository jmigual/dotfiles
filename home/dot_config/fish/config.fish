# Source first thing to load the PATH
set -x CUSTOM_SHELL_DIR "$HOME/.local/share/shell"
source "$CUSTOM_SHELL_DIR/variables.fish"

starship init fish | source

source "$CUSTOM_SHELL_DIR/alias.fish"
source "$CUSTOM_SHELL_DIR/functions.fish"

if status --is-interactive;
    source "$CUSTOM_SHELL_DIR/interactive.fish"
end
