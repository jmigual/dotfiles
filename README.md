# dotfiles

Repo containing my personal files and environment. If you want to use it do the following:

On Windows:

```pwsh
'$params = "-b ~/.local/bin init --apply --force jmigual"', (irm https://chezmoi.io/get.ps1) | powershell -c -
```

On Linux/Unix:

```sh
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b $HOME/.local/bin init --apply jmigual 
```

Packages used by the dotfiles:

- Windows:
    - 7zip
    - git
    - oh-my-posh
- Linux / Unix:
    - All:
        - zsh
        - socat
        - git
        - fortune
        - cowsay
    - WSL2:
        - ss


Recommended packages:
- Windows:
    - nodejs-lts (scoop)
    - cmake
    - fd (scoop)
    - ripgrep (scoop)
    - bat (scoop)
    - less (scoop)
    - lsd (scoop)
- Linux:
    - gcc
    - cmake
    - fd
    - ripgrep
    - bat
    - lsd
    - pipx
        - yt-dlp




