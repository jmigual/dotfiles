# PATH configuration. The reset drops whatever the environment appended (WSL adds
# the whole Windows PATH), so it only runs in the outermost shell: nested ones
# (nix develop, venvs, distrobox...) must keep what their parent added.
if not set -q PATH_OLD
    set -x PATH_OLD $PATH

    set -x PATH "$HOME/.local/bin"

    fish_add_path --path --append "$HOME/.cargo/bin"
    fish_add_path --path --append "$HOME/.local/share/juliaup/bin"
    fish_add_path --path --append "$HOME/.dotnet/tools"

    # System user commands
    fish_add_path --path --append "/usr/local/bin" "/usr/local/share/bin"
    # System commands
    fish_add_path --path --append "/bin" "/sbin" "/usr/bin" "/usr/sbin" "/snap/bin"
    # Games
    fish_add_path --path --append "/usr/games" "/usr/local/games"
end

set -x PAGER "less"

# Locale picked by chezmoi at apply time (see locale.tmpl)
set -l l C.UTF-8
test -r "$HOME/.local/share/shell/locale"; and read l < "$HOME/.local/share/shell/locale"
set -x LC_ALL $l
set -x LANG $l

# XDG variables
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_STATE_HOME "$HOME/.local/state"

if command -vq fd
    set -x FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix"
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end

# Unquoted so an unset LD_LIBRARY_PATH contributes nothing (a "" entry means CWD)
set -x --path LD_LIBRARY_PATH $LD_LIBRARY_PATH "$HOME/.local/lib" "$HOME/.local/lib64"

switch (uname -a)
    case "Linux*"
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

        if cat /proc/version | grep -qi Microsoft;
            # Check if the cmd.exe and wslpath commands are available
            set WIN_CMD_PATH "/mnt/c/Windows/System32/cmd.exe"
            if command -v $WIN_CMD_PATH > /dev/null; and command -v wslpath > /dev/null
                set -x WIN_HOME (/mnt/c/Windows/System32/cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null; or true)
                set -x WIN_HOME_WSL (wslpath "$WIN_HOME")

                # Add specific entries from Windows (such as code, docker...) to PATH
                fish_add_path --path --append "$WIN_HOME_WSL/AppData/Local/Programs/Microsoft VS Code/bin"
                fish_add_path --path --append "/mnt/c/Program Files/Docker/Docker/resources/bin"
                fish_add_path --path --append "/mnt/wsl/docker-desktop/cli-tools/usr/bin"
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

# If homebrew is there, add it
if [ -e "/home/linuxbrew/.linuxbrew/bin" ]
    fish_add_path --path "/home/linuxbrew/.linuxbrew/bin"
else if [ -e "/opt/homebrew/bin" ]
    fish_add_path --path "/opt/homebrew/bin"
end
