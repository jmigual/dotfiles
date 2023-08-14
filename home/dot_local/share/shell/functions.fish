set -x PROJECTS_PATH "$HOME/Projects"

function up
    if test (count $argv) -gt 0
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

function pj --description "Jump to a project"
    set -l argc (count $argv)

    if test $argc -gt 1
        echo "Usage: pj <project_name>"
        return 1
    end

    if test $argc -le 0
        cd "$PROJECTS_PATH"
    end

    set -l target "$PROJECTS_PATH/$argv"
    if test -n "$target"
        cd "$target"
    else
        echo "No such project: $argv"
        return 1
    end
end

function __project_basenames --description "List of project basenames"
    set -l project_basenames

    for pp in $PROJECTS_PATH
        set -l contains_files (ls -A "$pp" 2> /dev/null)
        if test -n "$contains_files"
            for project in (ls -d "$pp"/*/)
                set -a project_basenames "$project_basenames" (basename $project)
            end
        end
    end
    echo $project_basenames
end

complete --command pj --no-files --arguments=(__project_basenames)

if command -v pyenv &> /dev/null;
	set -x PYENV_ROOT "$HOME/.pyenv"
    fish_add_path "$PYENV_ROOT/bin" 
	pyenv init - | source
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

