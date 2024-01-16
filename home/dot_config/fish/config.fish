# Source first thing to load the PATH
set -x CUSTOM_SHELL_DIR "$HOME/.local/share/shell"
source "$CUSTOM_SHELL_DIR/variables.fish"

starship init fish | source

source "$CUSTOM_SHELL_DIR/alias.fish"
source "$CUSTOM_SHELL_DIR/functions.fish"

if status --is-interactive;
    source "$CUSTOM_SHELL_DIR/interactive.fish"

    # VSCode shell integration
    if string match -q "$TERM_PROGRAM" "vscode" && command -vq code && code --version | string match -vq "*CLI*"
        . (code --locate-shell-integration-path fish)
    end
end


function fish_greeting
    fortune -s | xargs -0 cowsay
end