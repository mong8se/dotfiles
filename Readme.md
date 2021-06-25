What? More Dotfiles?!
=====================

Config Order
------------
_Note:_ `hostname` below is the output of the "rake hostname" task. `_platform` files are only loaded if they're _mac or _linux prefixed files on the correct platform.

* vim
    1. plugs.vim
    1. _platform.plugs.vim
    1. _`hostname`.plugs.vim
    1. local.plugs.vim
    1. vimrc
    1. _platform.vim
    1. _`hostname`.vim
    1. local.vim
* fish
    1. config.fish
    1. _platform.fish
    1. _`hostname`.fish
    1. local.fish
* zsh
    1. zshrc
    1. _platform.zsh
    1. _`hostname`.zsh
    1. local.zsh

Rake tasks
----------

```
rake hostname          # first 12 characters of a sha2 digest of the non-fully-qualified hostname

rake init              # Initialize new dotfiles install
rake install           # install .dotfiles into home directory
rake update            # install new and remove old symlinks
rake upgrade           # Update submodules, vim, and fzf

rake cleanup           # clean up .dotfile symlinks that are no longer there
rake implode           # remove all .dotfile symlinks

rake make_alias_links  # make dot file symlinks

rake submodule:init    # init git submodules
rake submodule:update  # update git submodules to their latest master

rake vim:cleanup       # clean vim plugins
rake vim:install       # install vim plugins
rake vim:update        # update vim plugins

rake fzf:install       # install fzf
```

Required Packages
-----------------

bat
bc
fasd
fd
figlet
git-delta
highlight
lf
ripgrep
starship

Thanks to [ryanb](https://github.com/ryanb/dotfiles) for the starting point.
