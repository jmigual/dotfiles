# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH=~/.oh-my-zsh


# Bullet train configuration
BULLETTRAIN_PROMPT_CHAR=">"

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_BG=yellow
BULLETTRAIN_CONTEXT_FG=black
BULLETTRAIN_CONTEXT_DEFAULT_USER=jmigual

BULLETTRAIN_GIT_EXTENDED=false

BULLETTRAIN_CUSTOM_MSG=%T
BULLETTRAIN_CUSTOM_FG=black
BULLETTRAIN_CUSTOM_BG=white

BULLETTRAIN_PROMPT_ORDER=(
    #time
    status
    custom
    context
    dir
    #perl
    #ruby
    #virtualenv
    #aws
    #go
    #elixir
    git
    #hg
    cmd_exec_time
)

# ZSH Plugins configuration
HIST_STAMPS="yyyy-mm-dd"
PROJECT_PATHS=(~/Documents/Projects)

plugins=(git git-extras pip pj zsh-syntax-highlighting zsh-autosuggestions)
ZSH_THEME="bullet-train"
source $ZSH/oh-my-zsh.sh

# ZSH options
unsetopt BG_NICE
unsetopt share_history

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# To avoid mispelling errors
alias cd..="cd .."

alias la="ls -lahF"
alias ll="ls -lhF"
alias lah="ls -lah"

# Create parent directories on demand
alias mkdir="mkdir -pv"

# Command shortcuts to save time
alias h="history"
alias j="jobs"

# New set of commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Set vim as default
alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'

# Improved ping
alias fastping='ping -c 100 -s.2'

# Updir aliases
alias ..="cd .."
alias ...="cd ../.."

# Apt aliases
alias apt="sudo apt"
alias update="sudo apt update && sudo apt upgrade -y"

# Youtube aliases
alias yt='cd $HOME/Downloads; youtube-dl'
alias yt3='cd $HOME/Downloads; youtube-dl --embed-thumbnail --add-metadata --extract-audio --audio-format m4a'

# Allows to go up n levels
# use 'up 6' to go up 6 levels
function up {
    if [[ "$#" < 1 ]] ; then
        cd ..
    else
        CDSTR=""
        for i in {1..$1} ; do
            CDSTR="../$CDSTR"
        done
	echo $CDSTR
        cd $CDSTR
    fi
}

mkcd () { mkdir -p "$@" && cd "$@"; }

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Best part of the file
fortune | cowsay



