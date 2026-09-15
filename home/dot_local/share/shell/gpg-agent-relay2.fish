set wsl2_ssh_pageant_bin "$HOME/.local/bin/wsl2-ssh-pageant.exe"

mkdir -p "$HOME/.ssh" "$HOME/.local/bin"

# Check if exists and otherwise install
if ! test -x "$wsl2_ssh_pageant_bin";
    wget -O "$wsl2_ssh_pageant_bin" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    chmod +x "$wsl2_ssh_pageant_bin"
end

# Run `test_ssh_requirements` by hand when GPG or SSH stop working: it reports
# every broken piece of the relay, from missing tools to a dead Windows agent.
function test_ssh_requirements --description "Diagnose the WSL gpg/ssh agent relay"
  set -l bin "$HOME/.local/bin/wsl2-ssh-pageant.exe"
  set -l failed 0

  if not command -q socat
    echo >&2 "ERROR: socat is required to run this script. Install with apt install socat."
    set failed 1
  end
  if not command -q ss
    echo >&2 "ERROR: ss is required to run this script. Install with apt install iproute2."
    set failed 1
  end
  if not test -x "$bin"
    echo >&2 "ERROR: $bin is missing or not executable."
    set failed 1
  end

  for sock in "$HOME/.ssh/agent.sock" "$HOME/.gnupg/S.gpg-agent"
    if not test -S "$sock"
      echo >&2 "ERROR: $sock does not exist; open a new shell to recreate it."
      set failed 1
    else if command -q ss; and not ss -a 2>/dev/null | grep -q "$sock"
      echo >&2 "ERROR: nothing is listening on $sock (stale socket); open a new shell to recreate it."
      set failed 1
    end
  end

  # End to end: both go through the relay to the Windows gpg-agent.
  if not gpg-connect-agent --no-autostart /bye >/dev/null 2>&1
    echo >&2 "ERROR: the Windows gpg-agent does not answer through $HOME/.gnupg/S.gpg-agent. Is it running (gpg-connect-agent /bye on Windows)?"
    set failed 1
  end
  ssh-add -l >/dev/null 2>&1
  if test $status -eq 2
    echo >&2 "ERROR: no ssh agent answers on $SSH_AUTH_SOCK (enable-ssh-support / enable-putty-support in the Windows gpg-agent.conf?)."
    set failed 1
  end

  if test $failed -eq 0
    echo "All gpg/ssh relay requirements are met."
  end
  return $failed
end

set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
# Check if socket exists and is actually listening
if test -S "$SSH_AUTH_SOCK" && ss -a | grep -q "$SSH_AUTH_SOCK";
  # Socket exists and is active, do nothing
else
  # Socket is missing or stale, recreate it
  rm -f "$SSH_AUTH_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end

set -x GPG_AGENT_SOCK "$HOME/.gnupg/S.gpg-agent"
# Check if socket exists and is actually listening
if test -S "$GPG_AGENT_SOCK" && ss -a | grep -q "$GPG_AGENT_SOCK";
  # Socket exists and is active, do nothing
else
  # Socket is missing or stale, recreate it
  rm -rf "$GPG_AGENT_SOCK"
  if test -x "$wsl2_ssh_pageant_bin";
    setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  end
end
set --erase wsl2_ssh_pageant_bin
