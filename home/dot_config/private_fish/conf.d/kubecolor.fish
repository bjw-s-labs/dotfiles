# kubecolor setup
# Requires `brew install kubecolor`
if type -q kubecolor
  if status --is-interactive
    alias kubectl="kubecolor"
  end
end
