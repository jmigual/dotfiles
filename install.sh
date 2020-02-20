#!/usr/bin/env bash

main() {
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

    printf "${BLUE}Hi! We are going to install a new shell! 😄 ${NORMAL}\n"

    # Install zsh
    PACKAGES="zsh git fortune cowsay python3 curl"
    printf "${BLUE}Installing packages ${BOLD}${PACKAGES}${NORMAL}\n"
    sudo apt install ${PACKAGES} -y

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    printf "${BLUE}Creating ZSH_CUSTOM${NORMAL}\n"
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p $ZSH_CUSTOM

    # Add themes
    printf "${BLUE}Adding ${BOLD}Bullet train${NORMAL}${BLUE} to oh-my-zsh${NORMAL}\n"
    curl http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme -o $ZSH_CUSTOM/themes/bullet-train.zsh-theme

    printf "${BLUE}Adding ${BOLD}PowerLevel10k${NORMAL}${BLUE} to oh-my-zsh${NORMAL}\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    # Add syntax highlighting
    printf "${BLUE}Adding ${BOLD}zsh-syntax-highlighting${NORMAL}${BLUE} to oh-my-zsh${NORMAL}\n"
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    # Install pipenv and youtube-dl
    pip3 install -U pipenv youtube-dl

    # Create projects folder
    printf "${BLUE}Creating projects folder${NORMAL}\n"
    PROJECTS_DIR=$HOME/Documents/Projects
    cd ~/
    mkdir -p $PROJECTS_DIR
    cd $PROJECTS_DIR
    
    # Clone mybashrc and copy zshrc
    printf "${BLUE}Cloning mybashrc${NORMAL}\n"
    git clone git@github.com:jmigual/myBashrc
    cp $PROJECTS_DIR/myBashrc/.zshrc $PROJECTS_DIR/myBashrc/.zshenv ~/
}

main
