export ANDROID_HOME=$HOME/Android/Sdk

# Append a directory to PATH unless it is already there
path_append() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) export PATH="${PATH}:$1" ;;
    esac
}

# PATH configuration. The reset drops whatever the environment appended (WSL adds
# the whole Windows PATH), so it only runs in the outermost shell: nested ones
# (nix develop, venvs, distrobox...) must keep what their parent added.
if [ -z "${PATH_OLD+x}" ]; then
    export PATH_OLD="${PATH}"
    export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${HOME}/.dotnet/tools:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/snap/bin"
    export PATH="${PATH}:/usr/games:/usr/local/games"
    # Shims for non-interactive shells; interactive rc files run `mise activate` on top.
    command -v mise >/dev/null 2>&1 && eval "$(mise activate bash --shims)"
    # Locally built libraries (shared clusters); appended so system libraries keep priority.
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${HOME}/.local/lib:${HOME}/.local/lib64"
fi

export MANPATH="${HOME}/.local/share/man:${MANPATH}"
export PAGER=less

# XDG variables
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Locale picked by chezmoi at apply time (see locale.tmpl)
_l=C.UTF-8
[ -r "${HOME}/.local/share/shell/locale" ] && read -r _l < "${HOME}/.local/share/shell/locale"
export LANG="$_l"
unset _l

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Check current system
case "$(uname -s)" in
    Linux*)
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft; then
            # If WSLg not detected use the Xserver
            if [ ! -d /mnt/wslg ]; then
                export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
            fi

            export WIN_HOME=$(/mnt/c/Windows/System32/cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null || true)
            export WIN_HOME_WSL=$(wslpath "$WIN_HOME")

            # Add specific entries from Windows (such as code, docker...) to PATH
            path_append "${WIN_HOME_WSL}/AppData/Local/Programs/Microsoft VS Code/bin"
            path_append "/mnt/c/Program Files/Docker/Docker/resources/bin"
            path_append "/mnt/wsl/docker-desktop/cli-tools/usr/bin"
        fi
        ;;
    Darwin*)
        ;;
    *)
        echo UNKNOWN MACHINE!!!!
esac
path_append "${ANDROID_HOME}"

if [ -f "${HOME}/.linuxbrew/bin/brew" ]; then
    eval $(${HOME}/.linuxbrew/bin/brew shellenv)
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
elif [ -f "/opt/homebrew/bin/brew" ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

DEV_KEYS="${HOME}/.config/dev_keys"
if [ -f "${DEV_KEYS}" ]; then
    . "${DEV_KEYS}"
fi

export CUSTOM_SHELL_DIR="${HOME}/.local/share/shell"
