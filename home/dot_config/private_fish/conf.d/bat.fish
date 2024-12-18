# bat setup
# Requires `brew install bat`
if type -q bat
  if status --is-interactive
    alias cat="bat"
  end
end
