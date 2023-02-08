
source "${CUSTOM_SHELL_DIR}/alias.sh"
source "${CUSTOM_SHELL_DIR}/functions.sh"

case "$(uname -s)" in
    Linux*)     
		# Check if WSL
		if cat /proc/version | grep -qi Microsoft; then
            source "${CUSTOM_SHELL_DIR}/gpg-agent-relay2.sh"
		else
			gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye     
		fi
	    ;;
    Darwin*)    
	    ;;
    *)
esac
