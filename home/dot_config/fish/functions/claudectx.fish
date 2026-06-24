function claudectx
    set -l name $argv[1]
    set -l source ~/.claude/settings.$name.json

    if not test -f $source
        echo "Error: $source does not exist" >&2
        return 1
    end

    cp $source ~/.claude/settings.json
    echo "Switched Claude to $name"
end
