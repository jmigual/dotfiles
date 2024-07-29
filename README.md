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

## Packages

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
        - OpenSSH (winget)
        - fzf (scoop)
        - PowerShell modules:
            - [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) (`Install-Module -Name Terminal-Icons -Repository PSGallery`)
            - [PSFzf](https://github.com/kelleyma49/PSFzf) (`Install-Module -Name PSFzf`)
- Linux / Unix:
    - Required:
        - git
        - fortune
        - cowsay
        - socat: Required for SSH with Gpg running on Windows
        - ss: Idem
        - [starship](https://starship.rs/) (source)
    - Recommended:
        - zsh 
        - fish
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


## SSH with Gpg

### Windows

- Install [Gpg4win](https://www.gpg4win.org/)
- Import private key
- Set environment variable `GIT_SSH` to `C:\Program Files\OpenSSH\ssh.exe`
- Delete environment variable `SSH_AUTH_SOCK` if set
- Disable OpenSSH Authentication Agent service
- Add the following lines to `%APPDATA%\gnupg\gpg-agent.conf`:
```
enable-putty-support
enable-ssh-support
enable-win32-openssh-support
```
- Run `gpg -K --with-keygrip` and set the keygrip of the key to `%APPDATA%\gnupg\sshcontrol`. Make sure that the file has a single ending LF newline.

## Recommendations

### Windows

Sometimes the home is set to `HOMESHARE` (e.g. `\\campushome\myuser`). To prevent this, you can add the following to the `C:\Windows\System32\drivers\etc\hosts` file:

```txt
campushome 127.0.0.1
```
