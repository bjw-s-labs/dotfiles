function watch --description 'watch with fish alias support'
    if test (count $argv) -gt 0
        if type -q hwatch
            command hwatch -s "fish -c" $argv
        else
            command watch -x fish -c "$argv"
        end
    end
end
