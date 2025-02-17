

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."

alias l="ls -l"
alias la="ls -la"
alias lla="ls -la"

if ! command -v lsd &> /dev/null; 
    # lsd doesn't exist
    alias lt="ls"
else
    alias ls="lsd"
    alias lt="ls --tree --depth 3"
end

alias mkdir="mkdir -pv"

alias tnew="tmux new-session -A -s main"

function path
    string join \n $PATH
end
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias vi="vim"

alias fastping="ping -c 100 -s 0.2"

function update
    sudo apt update && sudo apt upgrade -y
end

alias doco="docker compose"
alias bell="echo -e '\a'"
