if not set -q HOMEBREW_PREFIX
  set -l brew_path

  for brew_path in /usr/local/bin/brew /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew ~/.linuxbrew/bin/brew
    if test -x $brew_path
      $brew_path shellenv | source
      break
    end
  end
end

set -x ASDF_DATA_DIR ~/.local/share/asdf
set -x ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY latest_installed
set -l asdf_shims "$ASDF_DATA_DIR/shims"
if not contains "$asdf_shims" $PATH
  set -gx --prepend PATH "$asdf_shims"
end
