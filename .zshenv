# Node, Android and go path configurations
NODE_MODULES_BIN=$HOME/.config/node_modules/bin
export ANDROID_HOME=$HOME/Android/Sdk

# Check current system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
	    export PATH=$PATH:$HOME/.local/bin
	    ;;
    Darwin*)    
	    export PATH=$PATH:$HOME/Library/Python/3.6/bin
	    ;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Go configuration
export GOPATH=$HOME/go
export GOROOT=/usr/local/go

# PATH configuration
export PATH=$PATH:/usr/games:/usr/local/bin
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$ANDROID_HOME:$NODE_MODULES_BIN
