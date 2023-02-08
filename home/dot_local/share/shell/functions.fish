function up
    if count $argv > 0
        set -f CDSTR ""
        for i in (seq 1 $argv[1])
            set CDSTR "$CDSTR../"
        end
        cd $CDSTR
    else
        cd ..
    end
end

function mkcd
    mkdir -p $argv && cd $argv
end

function extract
    if test -f $argv[1]
        switch $argv[1]
            case "*.tar.bz2"
                tar xjf $argv[1]
            case "*.tar.gz" "*.tgz"
                tar xzf $argv[1]
            case "*.tar.xz"
                tar xJf $argv[1]
            case "*.bz2"
                bunzip2 $argv[1] 
            case "*.rar"
                unrar x $argv[1] 
            case "*.gz"
                gunzip $argv[1] 
            case "*.tar"
                tar xvf $argv[1] 
            case "*.tbz2"
                tar xvjf $argv[1] 
            case "*.tgz"
                tar xvzf $argv[1] 
            case "*.zip"
                unzip $argv[1] 
            case "*.Z"
                uncompress $argv[1] 
            case "*.7z"
                7z x $argv[1] 
            case "*"
                echo "'$argv[1]' cannot be extracted via extract()" 
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

if command -v pyenv &> /dev/null;
	export PYENV_ROOT="$HOME/.pyenv"
	eval "$(pyenv init -)"
end

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
function _fzf_compgen_path
    fd --hidden --follow --exclude ".git" . "$1"
end

# Use fd to generate the list for directory completion
function _fzf_compgen_dir
    fd --type d --hidden --follow --exclude ".git" . "$1"
end

