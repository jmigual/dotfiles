
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

VSCODE_GUI=false
if command -v code &> /dev/null && ! (code --version | grep "CLI" &> /dev/null); then
	VSCODE_GUI=true
fi

# Check for editor
if $VSCODE_GUI; then
	export VISUAL="code"
elif command -v nvim &> /dev/null; then
	export VISUAL="nvim"
elif command -v vim &> /dev/null; then
	export VISUAL="vim"
fi
export EDITOR="${VISUAL}"

# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"
