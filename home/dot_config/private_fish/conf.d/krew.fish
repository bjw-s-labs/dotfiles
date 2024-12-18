# krew setup
# Requires `brew install krew`
if type -q kubectl-krew
  if status --is-interactive
    fish_add_path --global $HOME/.krew/bin
  end
end
