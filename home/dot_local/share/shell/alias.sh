
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# To avoid mispelling errors
alias cd..="cd .."

if ! command -v lsd &> /dev/null; then
    # lsd doesn't exist
    alias lt="ls"
else
    alias ls="lsd"
    alias lt="ls --tree --depth 3"
fi
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"

# Restore a session if it exists
alias tnew="tmux new-session -A -s main"

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
alias update="sudo apt update && sudo apt upgrade -y"

# Youtube aliases
alias yt='cd $HOME/Downloads; youtube-dl'
alias yt3='cd $HOME/Downloads; youtube-dl --embed-thumbnail --add-metadata --extract-audio --audio-format m4a'

# alias fd="find . -type d -name"
# alias ff="find . -type f -name"
alias sgrep="grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}"

alias doco="docker-compose"

# Updir aliases
alias ..="cd .."
alias ...="cd ../.."

# Command line head / tail shortcuts only in ZSH
if  [[ ! -z "$ZSH_NAME" ]]; then
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
fi