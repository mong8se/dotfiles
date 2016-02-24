What? More Dotfiles?!
=====================

Config Order
------------
_Note:_ `hostname` below is the actual hostname of the machine. `mac` files are only loaded if on a mac.

* vim
    1. plugs.vim
    1. mac.plugs.vim
    1. _`hostname`.plugs.vim
    1. local.plugs.vim
    1. vimrc
    1. mac.vim
    1. _`hostname`.vim
    1. local.vim
* fish
    1. config.fish
    1. mac.fish
    1. _`hostname`.fish
    1. local.fish
* zsh
    1. zshrc
    1. mac.zsh
    1. _`hostname`.zsh
    1. local.zsh

Rake tasks
----------

```
rake update            # install new and remove old symlinks *default*
rake install           # install .dotfiles into home directory
rake cleanup           # clean up .dotfile symlinks that are no longer there
rake implode           # remove all .dotfile symlinks

rake submodule:init    # init git submodules
rake submodule:update  # update git submodules to their latest master

rake vim:install       # install vim plugins
rake vim:update        # update vim plugins
rake vim:cleanup       # clean vim plugins
```
