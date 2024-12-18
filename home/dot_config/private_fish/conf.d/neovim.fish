# neovim setup
# Requires `brew install neovim`
if type -q nvim
  set -gx EDITOR nvim
  if status --is-interactive
    alias vi="nvim"
    alias vim="nvim"
  end
end
