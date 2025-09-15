
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if command -vq wslinfo;
            # We are in WSL, start gpg-relay agent
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
end

# Check if WSL_DISTRO_NAME is missing or empty and add a default value otherwise
if not set -q WSL_DISTRO_NAME
    set -x WSL_DISTRO_NAME "Ubuntu"
end

set VSCODE_GUI false
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
