# Registers a logon task that starts gpg-agent for the user running this script,
# so SSH through gpg-agent works before any shell is opened.
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$gpgConnectAgent = [System.IO.Path]::GetFullPath((Get-Command gpg-connect-agent -ErrorAction Stop).Source)

$action = New-ScheduledTaskAction -Execute $gpgConnectAgent -Argument "/bye"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $user
$trigger.Delay = "PT1M"
$trigger.ExecutionTimeLimit = "PT30M"
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName "GpgAgent" -Description "Start gpg agent" `
    -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
