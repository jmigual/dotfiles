set -x PATH_OLD $PATH

set -x PATH "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.local/share/juliaup/bin"

# System user commands
fish_add_path --path --append "/usr/local/bin" "/usr/local/share/bin"
# System commands
fish_add_path --path --append "/bin" "/sbin" "/usr/bin" "/usr/sbin" "/snap/bin"
# Games
fish_add_path --path --append "/usr/games" "/usr/local/games"

set -x PAGER "less"

# XDG variables
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_STATE_HOME "$HOME/.local/state"

if command -vq fd
    set -x FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix"
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end

if locale -a | grep -Eiq "^C.UTF-?8";
	set -x LC_ALL C.UTF-8
end

set -x --path LD_LIBRARY_PATH "$LD_LIBRARY_PATH" "$HOME/.local/lib" "$HOME/.local/lib64"

switch (uname -a)
    case "Linux*"
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

        if cat /proc/version | grep -qi Microsoft;
            # Check if the cmd.exe and wslpath commands are available
            set WIN_CMD_PATH "/mnt/c/Windows/System32/cmd.exe"
            if command -v $WIN_CMD_PATH > /dev/null; and command -v wslpath > /dev/null
                set -x WIN_HOME (/mnt/c/Windows/System32/cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null; or true)
                set -x WIN_HOME_WSL (wslpath "$WIN_HOME")

                set -x WIN_GNUPG_HOME "$WIN_HOME\\AppData\\Roaming\\gnupg"
                set -x WIN_GNUPG_HOME_WSL (wslpath -u "$WIN_GNUPG_HOME")

                # In my case they are the same
                set -x WIN_AGENT_HOME "$WIN_GNUPG_HOME"
                set -x WSL_AGENT_HOME "$WIN_GNUPG_HOME_WSL"

                # Add specific entries from Windows (such as code, docker...) to PATH
                fish_add_path --path --append "$WIN_HOME_WSL/AppData/Local/Programs/Microsoft VS Code/bin"
                fish_add_path --path --append "/mnt/c/Program Files/Docker/Docker/resources/bin"
                fish_add_path --path --append "/mnt/wsl/docker-desktop/cli-tools/usr/bin/"
            else
                echo "cmd.exe or wslpath is not available."
            end
        else
            set -x GPG_TTY (tty)
        end
end

# Search for nix shell
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.fish" ]
    fish_add_path --prepend --path "$HOME/.nix-profile/bin"
    source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end
