
source "${CUSTOM_SHELL_DIR}/alias.sh"
source "${CUSTOM_SHELL_DIR}/functions.sh"

case "$(uname -s)" in
    Linux*)     
		# Check if WSL
		if cat /proc/version | grep -qi Microsoft; then
            source "${CUSTOM_SHELL_DIR}/gpg-agent-relay2.sh"
		else
			export GPG_TTY=$(tty)
			gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye     
		fi
	    ;;
    Darwin*)    
	    ;;
    *)
esac

# Check for editor. The VS Code GUI's `code` is a script; the standalone CLI (SSH, tunnels) is a
# native binary. --wait makes git wait for the file to close.
if command -v code &> /dev/null && [ "$(head -c 2 "$(command -v code)" 2>/dev/null)" = '#!' ]; then
	export VISUAL="code --wait"
elif command -v nvim &> /dev/null; then
	export VISUAL="nvim"
elif command -v vim &> /dev/null; then
	export VISUAL="vim"
fi
export EDITOR="${VISUAL}"
