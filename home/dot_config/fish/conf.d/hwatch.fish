if type -q hwatch
    set -gx HWATCH "--shell 'fish -c' --color --differences watch --with-scrollbar --no-help-banner --border --use-pty -K ctrl-c=force_cancel"

    abbr watch hwatch

    if ! type -q viddy
        abbr viddy hwatch
    end
end
