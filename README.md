# dotfiles

Repo containing my personal files and environment. If you want to use it do the following:

On Windows:
    '$params = "-b ~/.local/bin init --apply --branch chezmoi --force jmigual"', (irm https://chezmoi.io/get.ps1) | powershell -c -
On Linux/Unix:
    sh -c "$(curl -fsLS chezmoi.io/get)" -- -b $HOME/.local/bin init --apply --branch chezmoi jmigual 



