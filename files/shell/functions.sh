
# Allows to go up n levels
# use 'up 6' to go up 6 levels
function up {
    if [[ "$#" < 1 ]] ; then
        cd ..
    else
        CDSTR=""
        for i in {1..$1} ; do
            CDSTR="../${CDSTR}"
        done
	    echo "${CDSTR}"
        cd "${CDSTR}"
    fi
}

mkcd () { mkdir -p "$@" && cd "$@"; }

tar-progress() {
    BYTES=$(du -scb "${@:2}" | grep "total" | awk '{print $1}')
    tar cf - "${@:2}" -P | pv -s $BYTES | pigz > $1
}

extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"      ;;
            *.tar.gz)   tar xzf "$1"      ;;
            *.bz2)      bunzip2 "$1"      ;;
            *.rar)      rar x "$1"        ;;
            *.gz)       gunzip "$1"       ;;
            *.tar)      tar xf "$1"       ;;
            *.tbz2)     tar xjf "$1"      ;;
            *.tgz)      tar xzf "$1"      ;;
            *.zip)      unzip "$1"        ;;
            *.Z)        uncompress "$1"   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Check current system
case "$(uname -s)" in
    Linux*)     
		# Check if WSL
		if cat /proc/version | grep -qi Microsoft; then
			# We are in WSL, start gpg-relay agent
            # $HOME/.local/bin/gpg-agent-relay start
            source "${CUSTOM_SHELL_DIR}/gpg-agent-relay2.sh"
		fi
	    ;;
    Darwin*)    
	    ;;
    *)
esac
