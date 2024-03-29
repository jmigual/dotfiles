
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

pj() {
    cd ${HOME}/Projects/"$1"
}

if command -v pyenv &> /dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
fi

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
