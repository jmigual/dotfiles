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

These are the list of packages recommended in a system and recommended install source:

- Windows:
    - Required:
        - git (winget)
        - 7zip (scoop)
        - [starship](https://starship.rs/) (scoop)
        - [PSReadLine](https://github.com/PowerShell/PSReadLine) (`Install-Module PSReadLine`)
    - Recommended:
        - less (scoop)
        - [nodejs-lts](https://nodejs.org/) (scoop)
        - [cmake](https://cmake.org/) (scoop)
        - [fd](https://github.com/sharkdp/fd) (scoop)
        - [ripgrep](https://github.com/BurntSushi/ripgrep) (scoop)
        - [bat](https://github.com/sharkdp/bat) (scoop)
        - [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) (`Install-Module -Name Terminal-Icons -Repository PSGallery`)
        - [PSFzf](https://github.com/kelleyma49/PSFzf) (`Install-Module -Name PSFzf`)
- Linux / Unix:
    - Required:
        - zsh 
        - fish
        - socat
        - git
        - fortune
        - cowsay
        - ss
        - [starship](https://starship.rs/) (source)
    - Recommended:
        - gcc
        - ninja
        - [cmake](https://cmake.org/download/) (source)
        - [fd-find](https://github.com/sharkdp/fd) (cargo)
        - [ripgrep](https://github.com/BurntSushi/ripgrep) (cargo)
        - [bat](https://github.com/sharkdp/bat) (cargo)
        - [lsd](https://github.com/lsd-rs/lsd) (cargo)
        - [flamegraph](https://github.com/flamegraph-rs/flamegraph) (cargo)
        - pipx (pip)
        - yt-dlp (pipx)
        - socat (apt)


## SSH with Gpg

### Windows

- Install [Gpg4win](https://www.gpg4win.org/)
- Import private key
- Set environment variable `GIT_SSH` to `C:\Windows\System32\OpenSSH\ssh.exe`
- Set environment variable `SSH_AUTH_SOCK` to `\\.\pipe\ssh-pageant`
- Install [WSL-SSH-Pageant](https://github.com/benpye/wsl-ssh-pageant/releases)
- Run `wsl-ssh-pageant.exe  --systray --winssh ssh-pageant` on startup
- Add the following lines to `%APPDATA%\gnupg\gpg-agent.conf`:
```
enable-putty-support
enable-ssh-support
```
- Run `gpg -K --with-keygrip` and set the keygrip of the key to `%APPDATA%\gnupg\sshcontrol`

