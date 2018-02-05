# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/games:$HOME/.local/bin:$HOME/bin:/usr/local/bin
export ZSH=~/.oh-my-zsh


# Bullet train configuration
BULLETTRAIN_PROMPT_CHAR=">"

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_BG=yellow
BULLETTRAIN_CONTEXT_FG=black
BULLETTRAIN_CONTEXT_DEFAULT_USER=joan

BULLETTRAIN_GIT_EXTENDED=false

BULLETTRAIN_EXEC_TIME_ELAPSED=5

BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    perl
    #ruby
    virtualenv
    #aws
    go
    #elixir
    git
    #hg
    cmd_exec_time
)
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"
PROJECT_PATHS=(~/Documents/Projects)

plugins=(git git-extras pip yarn pj zsh-syntax-highlighting)
ZSH_THEME="bullet-train"
source $ZSH/oh-my-zsh.sh

unsetopt BG_NICE
unsetopt share_history

export ANDROID_HOME=$HOME/Android/Sdk
export NODE_MODULES=$HOME/.config/node_modules

# Go configuration
export GOPATH=$HOME/Projects/gopath
export PATH=$PATH:$GOPATH/bin:$ANDROID_HOME:$NODE_MODULES

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
alias yt='cd $HOME/Downloads; youtube-dl --verbose'
alias yt3='cd $HOME/Downloads; youtube-dl --verbose --extract-audio --audio-format mp3'

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

# Best part of the file
fortune | cowsay


eval $(thefuck --alias)
