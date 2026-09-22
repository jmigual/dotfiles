# dotfiles

Repo containing my personal configuration files and environment. The files can be setup using [chezmoi](https://chezmoi.io). If you want to use them do the following:

On Windows:

```pwsh
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' init --apply --force jmigual"
```

On Linux/Unix:

```sh
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b $HOME/.local/bin init --apply jmigual 
```

This will download chezmoi in the `~/.local/bin/` folder, initialize the repository and apply the configuration. The configuration will be stored in the `~/.local/share/chezmoi` directory. `init` asks whether this is a work machine; answer again later with `chezmoi init` (or `chezmoi init --promptBool work=true`).

## Documentation

- [Codex setup and configuration](docs/codex.md)

## Tests

The Claude Code and Codex templates have tests under `extra/tests`. `mise` provides `uv`, which fetches a suitable Python on its own:

```sh
mise install
uv run python -m unittest discover -s extra/tests
```

## Packages

These are the list of packages recommended in a system and recommended install source (in parenthesis):

- Windows:
  - Required:
    - [git](https://git-scm.com/) (winget)
    - [7zip](https://www.7-zip.org/) (scoop)
    - [starship](https://starship.rs/) (scoop)
    - [mise](https://mise.jdx.dev/) (scoop): tool version manager, also provides `uv` for the repo tests
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
    - ss (`apt install iproute2`): Idem
    - [starship](https://starship.rs/) (installed to `~/.local/bin` by a chezmoi run-once script)
  - Recommended:
    - cargo (comes with [rust toolchain](https://www.rust-lang.org/tools/install))

      ```sh
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      ```

    - [mise](https://mise.jdx.dev/) (`curl https://mise.run | sh`): tool version manager, also provides `uv` for the repo tests
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
- Delete environment variable `SSH_AUTH_SOCK` if set
- Disable OpenSSH Authentication Agent service
- `chezmoi apply` already sets `GIT_SSH` and writes `%APPDATA%\gnupg\gpg-agent.conf` with the ssh/putty/win32-openssh support lines
- Run `gpg -K --with-keygrip` and set the keygrip of the key to `%APPDATA%\gnupg\sshcontrol`. Make sure that the file has a single ending LF newline.
- Start gpg-agent at logon: `pwsh extra/scripts/register_gpg_agent_task.ps1` (registers the task for the current user)

### Linux

- Import private key
- List the keys with keygrip: `gpg -K --with-keygrip`
- Mark the desired key as "Use-for-ssh": `gpg-connect-agent 'keyattr <auth keygrip> Use-for-ssh: true' /bye`

## Recommendations

### Windows

Sometimes the home is set to `HOMESHARE` (e.g. `\\campushome\myuser`). To prevent this, you can add the following to the `C:\Windows\System32\drivers\etc\hosts` file:

```txt
campushome 127.0.0.1
```

## LLMs

### Claude Code

Claude Code's instructions (`CLAUDE.md`, `coding-style.md`), agents, skills, and settings are managed under `home/dot_claude`.
`settings.json` is a modify template: it merges the shared keys (model, effort, auto mode, hooks, plugin toggles, claude.ai connectors disabled) and keeps everything else local.
`~/.claude/machine.md` and `~/.claude/RTK.md` (written by `rtk init -g`) are machine-local.
Apply them with:

```sh
chezmoi apply --exclude=scripts ~/.claude
```

Plugins are only toggled by the settings; install them once per machine (see [MCPs and plugins](#mcps-and-plugins)).

### Codex

Portable Codex settings, agents, skills, and hooks are managed under `home/dot_codex`.
Apply them with:

```sh
chezmoi apply --exclude=scripts ~/.codex
```

### Tools

- [Claude](https://claude.ai/): LLM with a focus on safety and reliability. It is a good alternative to ChatGPT.

    ```sh
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    On Windows:

    ```pwsh
    irm https://claude.ai/install.ps1 | iex
    ```

### MCPs and plugins

Recommended MCPs and plugins for LLMs:

- [Serena](https://github.com/oraios/serena). MCP with semantic access to files. Install with:

    ```sh
    uv tool install -p 3.13 serena-agent
    serena setup claude-code
    ```

- [Context7](https://context7.com): MCP with documentation. The shared Claude Code settings disable the `context7-mcp` skill because the MCP's own instructions already cover it. Install with:

    ```sh
    npx ctx7 setup
    ```

- [rtk](https://github.com/rtk-ai/rtk): CLI proxy that compresses the output of common commands to save tokens. Its Claude Code hook is managed by chezmoi. Install with:

    ```sh
    cargo install --git https://github.com/rtk-ai/rtk
    rtk init -g
    ```

- [CodeGraph](https://github.com/colbymchenry/codegraph): MCP for code analysis. Install with:

    ```sh
    npm i -g @colbymchenry/codegraph
    codegraph install
    ```

- [Ponytail](https://github.com/DietrichGebert/ponytail): Plugin to reduce amount of code written to a minimum that solves the issue. Run inside claude:

    ```sh
    /plugin marketplace add DietrichGebert/ponytail
    /plugin install ponytail@ponytail
    ```

- [Playwright](https://github.com/microsoft/playwright-mcp): browser automation MCP, installed as the official Claude Code plugin (Codex launches it with npx). Run inside claude:

    ```sh
    /plugin install playwright@claude-plugins-official
    ```
