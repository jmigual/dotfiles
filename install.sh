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
    PACKAGES="zsh git fortune python3 python3-venv curl"
    if [[ ! `sudo -v` ]]; then
      printf "${BLUE}Installing packages ${BOLD}${PACKAGES}${NORMAL}\n"
      sudo apt update && sudo apt install ${PACKAGES} -y
    fi

    # Install pip
    curl "https://bootstrap.pypa.io/get-pip.py" | python3
    export PATH="$PATH:$HOME/.local/bin"

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    printf "${BLUE}Creating ZSH_CUSTOM${NORMAL}\n"
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p $ZSH_CUSTOM

    # Add themes
    printf "${BLUE}Adding ${BOLD}PowerLevel10k${NORMAL}${BLUE} to oh-my-zsh${NORMAL}\n"
    git clone --depth=1 --branch v1.14.6 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    # Add syntax highlighting
    printf "${BLUE}Adding ${BOLD}zsh-syntax-highlighting${NORMAL}${BLUE} to oh-my-zsh${NORMAL}\n"
    git clone --depth=1 --branch 0.7.1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone --depth=1 --branch v0.6.4 https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    chmod 755 $ZSH_CUSTOM/plugins/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    
    # Install pipenv and youtube-dl
    pip3 install --user --upgrade pipx
    for package in poetry youtube-dl; do
        pipx install $package
    done

    # Create projects folder
    printf "${BLUE}Creating projects folder${NORMAL}\n"
    PROJECTS_DIR="$HOME/Documents/Projects"
    mkdir -p $PROJECTS_DIR
    cd $PROJECTS_DIR
    
    # Clone mybashrc and copy zshrc
    printf "${BLUE}Cloning mybashrc${NORMAL}\n"
    git clone --depth=1 https://github.com/jmigual/myBashrc
    cp $PROJECTS_DIR/myBashrc/.zshrc $PROJECTS_DIR/myBashrc/.zshenv "$HOME"

    # Download cowsay
    COWSAY_VERSION=v3.7.0
    mkdir -p $HOME/Downloads && cd $HOME/Downloads
    wget https://github.com/cowsay-org/cowsay/archive/${COWSAY_VERSION}.tar.gz
    tar xf ${COWSAY_VERSION}.tar.gz
    mv cowsay-* cowsay
    cd cowsay
    make install prefix=$HOME/.local
    cd $HOME
    rm -r $HOME/Downloads/cowsay $HOME/Downloads/${COWSAY_VERSION}.tar.gz
}

main
