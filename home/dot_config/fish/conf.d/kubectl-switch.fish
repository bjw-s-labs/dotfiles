if type -q kubectl-switch
  set -gx KUBECONFIG_DIR $HOME/.kube/configs

  abbr kns kubectl-switch ns
  abbr kc kubectl-switch context
end
