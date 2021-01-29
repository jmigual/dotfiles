# Node, Android and go path configurations
NODE_MODULES_BIN=$HOME/.config/node_modules/bin
export ANDROID_HOME=$HOME/Android/Sdk

# PATH configuration
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/snap/bin
export PATH=$PATH:/usr/games:/usr/local/games

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Check current system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
	    export PATH=$HOME/.local/bin:$PATH

		# Check if WSL
		if cat /proc/version | grep -qi Microsoft; then
			# We are in WSL, thus start gpg-relay agent
			bash $HOME/.local/bin/gpg-agent-relay start
		else
			gpgconf --launch gpg-agent
			gpg-connect-agent updatestartuptty /bye
		fi

	    ;;
    Darwin*)    
		# MacOs
	    export PATH=$HOME/Library/Python/3.6/bin:$PATH
	    ;;
    *)
	    echo UNKOWN MACHINE!!!!
esac
export PATH=$PATH:$NODE_MODULES_BIN:$ANDROID_HOME

DEV_KEYS="$HOME/.config/dev_keys"

if [ -f "$DEV_KEYS" ]; then
	source "$DEV_KEYS"
fi



