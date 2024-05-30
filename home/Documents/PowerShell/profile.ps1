
if ($Host.Name -match "ConsoleHost") {
    if ($PSVersionTable.PSVersion -ge [version]"6.0.0") {
        Invoke-Expression (&starship init powershell)
    }

    $psmodule = Get-Module -ListAvailable -Name "PSReadLine"
    if ($psmodule) {
        Import-Module PSReadLine

        # Shows navigable menu of all options when hitting Tab
        Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

        # Autocompletion for arrow keys
        Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

        # Check if version 2.1.0 or higher and PowerShell version higher than 7.2 as AcceptSuggestion 
        # was added in that version
        if (($psmodule | Where-Object { $_.Version -ge [version]"2.1.0" }) -and 
            ($PSVersionTable.PSVersion -ge [version]"7.2")) {
            # Allow plugins prediction
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin
            
            # Accept suggestions
            Set-PSReadlineKeyHandler -Chord "Ctrl+f" -Function AcceptSuggestion
            Set-PSReadlineKeyHandler -Chord "Alt+f" -Function AcceptNextSuggestionWord
        }
    }



    if (Get-Module -ListAvailable -Name "Terminal-Icons") {
        Import-Module -Name Terminal-Icons
    }

    if (Get-Module -ListAvailable -Name "PSFzf") {
        Import-Module -Name PSFzf

        # replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    }

    if (Get-Module -ListAvailable -Name "git-aliases") {
        Import-Module git-aliases -DisableNameChecking
    }
    if (Get-Module -ListAvailable -Name "CompletionPredictor") {
        Import-Module CompletionPredictor
    }

}

# VSCode shell integration
if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }

# Useful shortcuts for traversing directories
function .. { 
    if ($args.Count -gt 0) {
        Set-Location ..\$args
    }
    else {
        Set-Location ..
    }
}
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function cd.. { Set-Location .. }
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

function open {
    if ($args.Count -gt 0) {
        Invoke-Item $args
    }
    else {
        Invoke-Item .
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
        Set-Location "$env:USERPROFILE\Projects\$args"
    }
    else {
        Set-Location "$env:USERPROFILE\Projects\"
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

function path {
    $env:PATH -split ";"
}

$condapath = "$env:USERPROFILE\.local\share\Miniconda3\Scripts\conda.exe"

if (Test-Path "$condapath") {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    # (& "$condapath" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion
}

