set wsl2_ssh_pageant_bin "$HOME/.ssh/wsl2-ssh-pageant.exe"

if ! test -d "$HOME/.ssh";
  mkdir -p "$HOME/.ssh"
end

# Check if exists and otherwise install
if ! test -x "$wsl2_ssh_pageant_bin";
    wget -O "$wsl2_ssh_pageant_bin" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    chmod +x "$wsl2_ssh_pageant_bin"
end

function test_ssh_requirements
  if not command -v socat >/dev/null;
    echo >&2 "ERROR: socat is required to run this script. Install with apt install socat."
    return 1
  end
  if not command -v ss >/dev/null;
    echo >&2 "ERROR: ss is required to run this script. Install with apt install iproute2."
    return 1
  end
  if not command -v "$wsl2_ssh_pageant_bin" >/dev/null;
    echo >&2 "ERROR: $wsl2_ssh_pageant_bin is required to run this script."
    return 1
  end
  return 0
end

set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
if not ss -a | grep -q "$SSH_AUTH_SOCK";
  rm -f "$SSH_AUTH_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end

set -x GPG_AGENT_SOCK "$HOME/.gnupg/S.gpg-agent"
if not ss -a | grep -q "$GPG_AGENT_SOCK";
  rm -rf "$GPG_AGENT_SOCK"
  set wsl2_ssh_pageant_bin "$HOME/.ssh/wsl2-ssh-pageant.exe"
  if test -x "$wsl2_ssh_pageant_bin";
    setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end
set --erase wsl2_ssh_pageant_bin
