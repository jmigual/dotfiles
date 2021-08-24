
# Avoid installing if it is already installed
if (Get-Command "scoop" -ErrorAction SilentlyContinue) {
    scoop update
    exit 0
}

# Install basic scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop config SCOOP_REPO 'https://github.com/Ash258/Scoop-Core'
scoop update
scoop status
scoop checkup

