set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx LANG "en_US.utf-8"

set -gx VISUAL vim
set -gx EDITOR vim
set -gx KUBE_EDITOR vim

fish_add_path --global --prepend $HOME/.local/bin
