# kubecm setup
# Requires `brew install kubecm`
if type -q kubecm
  if status --is-interactive
    alias kc="kubecm"
  end
end
