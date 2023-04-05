# Node, Android and go path configurations
NODE_MODULES_BIN=$HOME/.config/node_modules/bin
export ANDROID_HOME=$HOME/Android/Sdk

# PATH configuration
PATH_OLD="${PATH}"
export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/snap/bin"
export PATH="${PATH}:/usr/games:/usr/local/games"

export MANPATH="${HOME}/.local/share/man:${MANPATH}"
export PAGER=less

if locale -a | grep -Eiq "^C.UTF-?8"; then
	export LC_ALL=C.UTF-8
fi
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib:$HOME/.local/lib64"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Check current system
case "$(uname -s)" in
    Linux*)     
		export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
		# Check if WSL
		if cat /proc/version | grep -qi Microsoft; then
			# If WSLg not detected use the Xserver
			if [[ ! -d /mnt/wslg ]]; then 
				export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
			fi

			export WIN_HOME=$(/mnt/c/Windows/System32/cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null || true)
			export WIN_HOME_WSL=$(wslpath $WIN_HOME)
			export WIN_GNUPG_HOME="${WIN_HOME}\\AppData\\Local\\gnupg"
			export WSL_GNUPG_HOME="$(wslpath -u "$WIN_GNUPG_HOME")"

			# In my case they are the same
			export WIN_AGENT_HOME="${WIN_GNUPG_HOME}"
			export WSL_AGENT_HOME="${WSL_GNUPG_HOME}"

			# Add specific entries from Windows (such as code, docker...) to PATH
			export PATH="${PATH}:${WIN_HOME_WSL}/AppData/Local/Programs/Microsoft VS Code/bin"

			WSL=/mnt/c/Windows/System32/wsl.exe
			$WSL -d wsl-vpnkit --cd /app service wsl-vpnkit status >/dev/null || \
				$WSL -d wsl-vpnkit --cd /app service wsl-vpnkit start
		else
			export GPG_TTY=$(tty)
			gpgconf --launch gpg-agent
		fi
	    ;;
    Darwin*)    
		# MacOs
	    export PATH="${HOME}/Library/Python/3.6/bin:${PATH}"
	    ;;
    *)
	    echo UNKOWN MACHINE!!!!
esac
export PATH="${PATH}:${NODE_MODULES_BIN}:${ANDROID_HOME}"

if [ -f "${HOME}/.linuxbrew/bin/brew" ]; then
    eval $(${HOME}/.linuxbrew/bin/brew shellenv)
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then 
	source "${HOME}/.nix-profile/etc/profile.d/nix.sh"; 
fi

# Check for editor
if command -v code &> /dev/null && ! (code --version | grep "CLI" &> /dev/null); then
	export VISUAL="code"
elif command -v nvim &> /dev/null; then
	export VISUAL="nvim"
elif command -v vim &> /dev/null; then
	export VISUAL="vim"
fi
export EDITOR="${VISUAL}"

DEV_KEYS="${HOME}/.config/dev_keys"
if [ -f "${DEV_KEYS}" ]; then
	source "${DEV_KEYS}"
fi

export CUSTOM_SHELL_DIR="${HOME}/.local/share/shell"

CARGO_ENV="${HOME}/.cargo/env"
if [ -f "${CARGO_ENV}" ]; then
    source "${CARGO_ENV}"
fi
