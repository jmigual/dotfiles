# Code extracted from: https://github.com/rupor-github/win-gpg-agent

if [ ! -d ${HOME}/.gnupg ]; then
    mkdir ${HOME}/.gnupg
    chmod 0700 ${HOME}/.gnupg
fi
if [ -n ${WIN_GNUPG_HOME} ]; then
    # setup gpg-agent socket
    _sock_name=${HOME}/.gnupg/S.gpg-agent
    ss -a | grep -q ${_sock_name}
    if [ $? -ne 0  ]; then
        rm -f ${_sock_name}
        ( setsid socat UNIX-LISTEN:${_sock_name},fork EXEC:"${HOME}/.local/bin/sorelay.exe -a ${WIN_GNUPG_HOME//\:/\\:}/S.gpg-agent",nofork & ) >/dev/null 2>&1
    fi
    # setup gpg-agent.extra socket
    _sock_name=${HOME}/.gnupg/S.gpg-agent.extra
    ss -a | grep -q ${_sock_name}
    if [ $? -ne 0  ]; then
        rm -f ${_sock_name}
        ( setsid socat UNIX-LISTEN:${_sock_name},fork EXEC:"${HOME}/.local/bin/sorelay.exe -a ${WIN_GNUPG_HOME//\:/\\:}/S.gpg-agent.extra",nofork & ) >/dev/null 2>&1
    fi
    unset _sock_name
fi
if [ -n ${WIN_AGENT_HOME} ]; then
    # and ssh-agent socket
    export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
    ss -a | grep -q ${SSH_AUTH_SOCK}
    if [ $? -ne 0  ]; then
        rm -f ${SSH_AUTH_SOCK}
        ( setsid socat UNIX-LISTEN:${SSH_AUTH_SOCK},fork EXEC:"${HOME}/.local/bin/sorelay.exe ${WIN_AGENT_HOME//\:/\\:}/S.gpg-agent.ssh",nofork & ) >/dev/null 2>&1
    fi
fi

