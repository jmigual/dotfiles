set PATH_OLD $PATH

# Home commands
set PATH "$HOME/.local/bin" "$HOME/.cargo/bin"
# System user commands
set PATH $PATH "/usr/local/bin" "/usr/local/share/bin"
# System commands
set PATH $PATH "/bin" "/sbin" "/usr/bin" "/usr/sbin" "/snap/bin"
# Games
set PATH $PATH "/usr/games" "/usr/local/games"

set -x PAGER "less"

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
            set -x WIN_HOME (/mnt/c/Windows/System32/cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null; or true)
            set -x WIN_HOME_WSL (wslpath "$WIN_HOME")
            set -x WIN_GNUPG_HOME "$WIN_HOME\\AppData\\Roaming\\gnupg"
            set -x WIN_GNUPG_HOME_WSL (wslpath -u "$WIN_GNUPG_HOME")

            # In my case they are the same
            set -x WIN_AGENT_HOME "$WIN_GNUPG_HOME"
            set -x WSL_AGENT_HOME "$WIN_GNUPG_HOME_WSL"

            # Add specific entries from Windows (such as code, docker...) to PATH
			set PATH $PATH "$WIN_HOME_WSL/AppData/Local/Programs/Microsoft VS Code/bin"
        else
            set -x GPG_TTY (tty)
        end
end

# Search for nix shell
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.fish" ]
    fish_add_path --prepend --path "$HOME/.nix-profile/bin"
    source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

# Check for editor
if command -vq code && code --version | string match -vq "*CLI*"
	set -x VISUAL "code"
else if command -vq nvim
    set -x VISUAL "nvim"
else if command -vq vim
	set -x VISUAL "vim"
end
set -x EDITOR "$VISUAL"
