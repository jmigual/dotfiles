# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=~/.oh-my-zsh

# ZSH Plugins configuration
HIST_STAMPS="yyyy-mm-dd"
PROJECT_PATHS=(~/Documents/Projects)

plugins=(git git-extras pip pj zsh-syntax-highlighting zsh-autosuggestions)

ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# ZSH options
unsetopt BG_NICE
unsetopt share_history
setopt rm_star_silent

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# To avoid mispelling errors
alias cd..="cd .."

alias l="ls -lFH"
alias la="ls -lahF"
alias lr="ls -tRFh"
alias lt="ls -ltFh"
alias ll="ls -l"
alias ldot="ls -ld .*"
alias lS="ls -1FSsh"
alias lart="ls -1Fcart"
alias lrt="ls -1Fcrt"

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

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

# Apt aliases
alias apt="sudo apt"
alias update="sudo apt update && sudo apt upgrade -y"

# Youtube aliases
alias yt='cd $HOME/Downloads; youtube-dl'
alias yt3='cd $HOME/Downloads; youtube-dl --embed-thumbnail --add-metadata --extract-audio --audio-format m4a'

alias fd="find . -type d -name"
alias ff="find . -type f -name"
alias grep="grep --color"
alias sgrep="grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}"

# Updir aliases
alias ..="cd .."
alias ...="cd ../.."

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

tar-progress() {
    BYTES=$(du -scb "${@:2}" | grep "total" | awk '{print $1}')
    tar cf - "${@:2}" -P | pv -s $BYTES | pigz > $1
}

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
fortune -s | xargs -0 cowsay

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

