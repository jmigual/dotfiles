
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft
            # VS Code's WSL integration breaks when the distro name is missing from
            # the environment (shells not spawned through wsl.exe).
            set -q WSL_DISTRO_NAME; or set -x WSL_DISTRO_NAME "Ubuntu"
            # We are in WSL, start gpg-relay agent
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
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
