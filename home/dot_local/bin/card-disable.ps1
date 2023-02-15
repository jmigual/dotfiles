# Disable external NVIDIA card

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
}

# Find the nvidia card
$result = PNPUtil /enum-devices /class display | Select-Object -Skip 2 | Select-String -Pattern 'Manufacturer Name:' -Context 4, 2 | 
Where-Object { $_.Line -replace '.*:\s+' -eq "NVIDIA" } | ForEach-Object {
    [PSCustomObject]@{
        InstanceId        = $PSItem.Context.PreContext[0] -replace '.*:\s+'
        DeviceDescription = $PSItem.Context.PreContext[1] -replace '.*:\s+'
        ClassName         = $PSItem.Context.PreContext[2] -replace '.*:\s+'
        ClassGUID         = $PSItem.Context.PreContext[3] -replace '.*:\s+'
        ManufacturerName  = $PSitem.Line -replace '.*:\s+'
        Status            = $PSItem.Context.PostContext[0] -replace '.*:\s+'
        DriverName        = $PSItem.Context.PostContext[1] -replace '.*:\s+'
    }
}

if ($result) {
    pnputil /disable-device $result.InstanceId
} else {
    Write-Output "No NVIDIA card found."
    Start-Sleep 10
}

