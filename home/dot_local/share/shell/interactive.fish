
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft;
            # We are in WSL, start gpg-relay agent
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
end

if command -vq code && code --version | string match -vq "*CLI*"
    set VSCODE_GUI true
end

# Check for editor
if $VSCODE_GUI
	set -x VISUAL "code"
else if command -vq nvim
    set -x VISUAL "nvim"
else if command -vq vim
	set -x VISUAL "vim"
end
set -x EDITOR "$VISUAL"

# VSCode shell integration
if string match -q "$TERM_PROGRAM" "vscode" && $VSCODE_GUI
    . (code --locate-shell-integration-path fish)
end
