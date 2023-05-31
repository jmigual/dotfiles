# Environment variables to use gpg-agent with ssh on Windows
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Windows\System32\OpenSSH\ssh.exe", "User")
[Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", "\\.\pipe\ssh-pageant", "User")
