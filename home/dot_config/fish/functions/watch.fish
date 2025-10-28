function watch --description 'watch with fish alias support'
  if test (count $argv) -gt 0
    if type -q viddy
      command viddy --disable_auto_save --differences --interval 2 --shell fish $argv[1..-1]
    else
      command watch -x fish -c "$argv"
    end
  end
end
