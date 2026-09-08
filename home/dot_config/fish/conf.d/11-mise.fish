if type -q mise
  if test "$VSCODE_RESOLVING_ENVIRONMENT" = 1
    command mise activate fish --shims | source
  else if status is-interactive
    command mise activate fish | source
  else
    command mise activate fish --shims | source
  end
end

if type -q fnox
    command fnox activate fish | source
end
