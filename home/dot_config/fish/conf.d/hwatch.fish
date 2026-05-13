if type -q hwatch
    set -gx HWATCH "--color --differences watch --with-scrollbar --no-help-banner --border --use-pty -K ctrl-c=force_cancel"
end
