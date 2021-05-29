$ErrorActionPreference = "Stop"

$BASEDIR = $PSScriptRoot
$PLUGINS_DIR = "plugins"
$DOTBOT_DIR = "dotbot"
$DOTBOT_BIN = "bin/dotbot"

$CONFIG_DIR = "config"
$CONFIG = $(Join-Path $CONFIG_DIR -ChildPath "install_pwsh.conf.yaml")

Set-Location $BASEDIR
git submodule update --init --recursive 

foreach ($PYTHON in ('python', 'python3', 'python2')) {
    # Python redirects to Microsoft Store in Windows 10 when not installed
    if (& { $ErrorActionPreference = "SilentlyContinue"
            ![string]::IsNullOrEmpty((&$PYTHON -V))
            $ErrorActionPreference = "Stop" }) {
        &$PYTHON $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) `
            --plugin-dir $(Join-Path $PLUGINS_DIR -ChildPath git) `
            --plugin-dir $(Join-Path $PLUGINS_DIR -ChildPath pip) `
            -d $BASEDIR -c $CONFIG $Args
        return
    }
}
Write-Error "Error: Cannot find Python."
