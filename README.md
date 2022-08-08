# dotfiles

Repo containing my personal files and environment. If you want to use it do the following:

On Windows:

```pwsh
'$params = "-b ~/.local/bin init --apply --branch chezmoi --force jmigual"', (irm https://chezmoi.io/get.ps1) | powershell -c -
```

On Linux/Unix:

```sh
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b $HOME/.local/bin init --apply --branch chezmoi jmigual 
```

Packages used by the dotfiles:

- Windows:
    - scoop:
        - 7zip
        - git
        - oh-my-posh
- Linux / Unix:
    - brew
        - zsh
        - socat
        - git
        - fortune
        - cowsay


Recommended packages:
- Windows:
    - scoop
        - nodejs-lts
        - cmake
        - fd
        - ripgrep
- Linux:
    - brew
        - gcc
        - cmake
        - fd
        - ripgrep
    - pipx
        - yt-dlp




