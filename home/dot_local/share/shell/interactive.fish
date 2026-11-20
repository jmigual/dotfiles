
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft
            # VS Code's WSL integration breaks when the distro name is missing from
            # the environment (shells not spawned through wsl.exe). The distro name is
            # the share in `\\wsl.localhost\<distro>\`, so it works for any distro.
            set -q WSL_DISTRO_NAME; or set -x WSL_DISTRO_NAME (string split '\\' (wslpath -w /))[4]
            # We are in WSL, start gpg-relay agent
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
end

# Check for editor. The VS Code GUI's `code` is a script; the standalone CLI (SSH, tunnels) is a
# native binary. --wait makes git wait for the file to close.
if command -vq code && string match -q '#!' -- (head -c 2 (command -v code) 2>/dev/null)
	set -x VISUAL "code --wait"
else if command -vq nvim
    set -x VISUAL "nvim"
else if command -vq vim
	set -x VISUAL "vim"
end
set -x EDITOR "$VISUAL"

# VSCode shell integration
if string match -q "$TERM_PROGRAM" "vscode"
    . (code --locate-shell-integration-path fish)
end
