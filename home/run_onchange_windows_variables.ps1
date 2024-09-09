# Environment variables to use gpg-agent with ssh on Windows
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Program Files\OpenSSH\ssh.exe", "User") 

# Set XDG variables
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$env:USERPROFILE\.config", "User")
[Environment]::SetEnvironmentVariable("XDG_DATA_HOME", "$env:USERPROFILE\.local\share", "User")
[Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", "$env:USERPROFILE\.cache", "User")
[Environment]::SetEnvironmentVariable("XDG_STATE_HOME", "$env:USERPROFILE\.local\state", "User")
