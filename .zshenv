# Node, Android and go path configurations
NODE_MODULES_BIN=$HOME/.config/node_modules/bin
export ANDROID_HOME=$HOME/Android/Sdk

# PATH configuration
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/snap/bin
export PATH=$PATH:/usr/games:/usr/local/games

# Check current system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
	    export PATH=$PATH:$HOME/.local/bin
	    ;;
    Darwin*)    
	    export PATH=$PATH:$HOME/Library/Python/3.6/bin
	    ;;
    *)
	    echo UNKOWN MACHINE!!!!
esac
export PATH=$PATH:$NODE_MODULES_BIN:$ANDROID_HOME
