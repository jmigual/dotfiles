Invoke-Expression (oh-my-posh --init --shell pwsh --config "$env:USERPROFILE\Documents\PowerShell\config.omp.json")
Import-Module git-aliases -DisableNameChecking
$DefaultUser = '20204729'

# Useful shortcuts for traversing directories
function .. { cd .. }
function cd.. { cd .. }
function cd... { cd ..\.. }
function cd.... { cd ..\..\.. }

function open {
    if ($args.Count -gt 0) {
        ii $args
    } else {
        ii .
    }
}

# Compute file hashes - useful for checking successful downloads 
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

# Creates drive shortcut for Work Folders, if current user account is using it
function pj {
    if ($args.Count -gt 0) {
        Set-Location "$env:USERPROFILE\Documents\Projects\$args"
    }
    else {
        Set-Location "$env:USERPROFILE\Documents\Projects\"
    }
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
