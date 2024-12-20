set -gx HOMEBREW_NO_ANALYTICS 1
# Specify where the brew bundle input file lives
set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/homebrew/brewfile
# Automatically remove quarantine flag from casks
set -gx HOMEBREW_CASK_OPTS --no-quarantine
# More frequent package updates
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
# Don't use vendored mise activation
set -gx MISE_FISH_AUTO_ACTIVATE 0

for bindir in /usr/local/bin /opt/homebrew/bin
  test -d $bindir && fish_add_path --global --prepend $bindir
end

type -q brew && eval (brew shellenv)

fish_add_path --global --prepend /opt/homebrew/opt/curl/bin

if type -q gdu
  fish_add_path --global --prepend $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
end

if type -q gsed
  fish_add_path --global --prepend $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
end

if type -q gawk
  fish_add_path --global --prepend $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
end

if type -q gfind
  fish_add_path --global --prepend /opt/homebrew/opt/findutils/libexec/gnubin
end
