if type -q kubectl-switch
    set -gx KUBECONFIG_DIR $HOME/.kube/configs

    abbr kubens kubectl-switch ns
    abbr kubectx kubectl-switch context
end
