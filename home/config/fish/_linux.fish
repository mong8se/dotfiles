# wl-clipboard
alias pbcopy="wl-copy"
alias pbpaste="wl-paste"

function isDarkMode -d "Is Gnome currently in Dark mode"
  gsettings get org.gnome.desktop.interface color-scheme | string match -q 'prefer-dark'
end
