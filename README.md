# dotfiles

Repo containing my personal configuration files and environment. The files can be setup using [chezmoi](https://chezmoi.io). If you want to use them do the following:

On Windows:

```pwsh
'$params = "-b ~/.local/bin init --apply --force jmigual"', (irm https://chezmoi.io/get.ps1) | powershell -c -
```

On Linux/Unix:

```sh
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b $HOME/.local/bin init --apply jmigual 
```

This will download chezmoi in the `~/.local/bin/` folder, initialize the repository and apply the configuration. The configuration will be stored in the `~/.local/share/chezmoi` directory.

## Packages

These are the list of packages recommended in a system and recommended install source (in parenthesis):

- Windows:
    - Required:
        - [git](https://git-scm.com/) (winget)
        - [7zip](https://www.7-zip.org/) (scoop)
        - [starship](https://starship.rs/) (scoop)
        - [PSReadLine](https://github.com/PowerShell/PSReadLine) (`Install-Module PSReadLine`)
    - Recommended:
        - [scoop](https://scoop.sh/): Package manager for windows that doesn't require admin rights
        - less (scoop)
        - [nodejs-lts](https://nodejs.org/) (scoop)
        - [cmake](https://cmake.org/) (scoop)
        - [fd](https://github.com/sharkdp/fd) (scoop): better `find` command
        - [ripgrep](https://github.com/BurntSushi/ripgrep) (scoop): better `grep` command
        - [bat](https://github.com/sharkdp/bat) (scoop): better `cat` command
        - OpenSSH (winget)
        - fzf (scoop)
        - PowerShell modules:
            - [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) (`Install-Module Terminal-Icons`)
            - [PSFzf](https://github.com/kelleyma49/PSFzf) (`Install-Module PSFzf`)
- Linux / Unix:
    - Required:
        - [git](https://git-scm.com/)
        - [fortune](https://github.com/shlomif/fortune-mod) (package manager or source)
        - cowsay
        - socat: Required for SSH with Gpg running on Windows
        - ss: Idem
        - [starship](https://starship.rs/) (cargo)
    - Recommended:
        - cargo (comes with [rust toolchain](https://www.rust-lang.org/tools/install))
        - zsh 
        - fish
        - gcc
        - ninja
        - [cmake](https://cmake.org/download/) (source)
        - [fd-find](https://github.com/sharkdp/fd) (cargo): better `find` command
        - [ripgrep](https://github.com/BurntSushi/ripgrep) (cargo): better `grep` command
        - [bat](https://github.com/sharkdp/bat) (cargo): better `cat` command
        - [lsd](https://github.com/lsd-rs/lsd) (cargo): better `ls` command
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
