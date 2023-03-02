# Disable external NVIDIA card

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
}

# Find the nvidia card
$result = Get-PnpDevice -class Display -FriendlyName "NVIDIA*"

if ($result) {
    $result | Disable-PnpDevice -Confirm:$false
} else {
    Write-Output "No NVIDIA card found."
    Start-Sleep 10
}

