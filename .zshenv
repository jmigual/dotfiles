# Node, Android and go path configurations
NODE_MODULES_BIN=$HOME/.config/node_modules/bin
export ANDROID_HOME=$HOME/Android/Sdk


# Go configuration
export GOPATH=$HOME/go
export GOROOT=/usr/local/go

# PATH configuration
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/snap/bin
export PATH=$PATH:/usr/games:/usr/local/games:$GOROOT/bin
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
export PATH=$PATH:$GOPATH/bin:$NODE_MODULES_BIN:$ANDROID_HOME
