#!/usr/bin/env bash

main {
    # Install zsh
    sudo apt install zsh git fortune cowsay python3 python3-pip -y

    # Use colors if the terminal supports them
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
        YELLOW="$(tput setaf 3)"
        BLUE="$(tput setaf 4)"
        BOLD="$(tput bold)"
        NORMAL="$(tput sgr0)"
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        NORMAL=""
    fi

    # Install oh my zsh
    ZSH =~/.oh-my-zsh
    env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
        printf "Error: git clone of oh-my-zsh repo failed\n"
        exit 1
    }

    # Check if we have to change the shell
    TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
    if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
        if hash chsh >/dev/null 2>&1; then 
            printf "${BLUE}Changing default shell to zsh!${NORMAL}\n"
            chsh -s $(grep /zsh$ /etc/shells | tail -1)
        else
            printf "I can't change your shell automatically because this system does not have chsh.\n"
            printf "${BLUE}Please manually change your default shell to zsh!${NORMAL}\n"
        fi
    fi

    printf "${GREEN}"
    echo '         __                                     __   '
    echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
    echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
    echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
    echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
    echo '                        /____/                       ....is now installed'
    printf "${NORMAL}"

    # Add bullet train theme
    printf "${BLUE}Adding ${BOLD}Bullet train${BLUE} to oh-my-zsh${NORMAL}\n"
    wget http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme > ~/.oh-my-zsh/themes/

    # Add syntax highlighting
    printf "${BLUE}Adding ${BOLD}zsh-syntax-highlighting${BLUE} to oh-my-zsh${NORMAL}\n"
    cd ~/.oh-my-zsh/custom/plugins
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

    # Create projects folder
    printf "${BLUE}Creating projects folder${NORMAL}\n"
    cd ~/
    mkdir -p ~/Documents/Projects/
    cd ~/Documents/Projects/
    
    # Clone mybashrc and copy zshrc
    printf "${BLUE}Cloning mybashrc${NORMAL}\n"
    git clone https://jmigual@github.com/jmigual/mybashrc
    cp ~/Documents/Projects/mybashrc/.zshrc ~/

    # Install the fuck
    printf "${BLUE}Installing the fuck${NORMAL}\n"
    sudo pip3 install thefuck
}

main