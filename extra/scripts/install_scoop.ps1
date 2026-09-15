# Install basic scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install 7zip git
scoop update
scoop status
scoop checkup
scoop install starship
