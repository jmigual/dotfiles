#!/usr/bin/env bash
# Found by:
# - https://github.com/BlackReloaded/wsl2-ssh-pageant
# - https://dev.to/dzerycz/the-ultimate-guide-to-yubikey-on-wsl2-part-2-kli
# For windows download the old one: https://github.com/benpye/wsl-ssh-pageant


# Check if exists and otherwise install
wsl2_ssh_pageant_bin="$HOME/.local/bin/wsl2-ssh-pageant.exe"
if ! test -x "$wsl2_ssh_pageant_bin"; then
    wget -O "$wsl2_ssh_pageant_bin" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    chmod +x "$wsl2_ssh_pageant_bin"
fi

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
  rm -f "$SSH_AUTH_SOCK"
  if test -x "$wsl2_ssh_pageant_bin"; then
    (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  fi
fi

export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
  rm -rf "$GPG_AGENT_SOCK"
  if test -x "$wsl2_ssh_pageant_bin"; then
    (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  fi
fi

unset wsl2_ssh_pageant_bin
