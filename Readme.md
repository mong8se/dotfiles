What? More Dotfiles?!
=====================

Config Order
------------

* vim
    1. plugs.vim
    1. mac.plugs.vim
    1. hostname.plugs.vim
    1. local.plugs.vim
    1. vimrc
    1. mac.vim
    1. hostname.vim
    1. local.vim
* zsh
    1. zshrc
    1. mac.zsh
    1. hostname.zsh
    1. local.zsh

Rake tasks
----------

```
rake install           # install .dotfiles into home directory
rake update            # install new and remove old symlinks
rake cleanup           # clean up .dotfile symlinks that are no longer there
rake implode           # remove all .dotfile symlinks
rake submodule:init    # init git submodules
rake submodule:update  # update git submodules to their latest tag
rake vim:install       # install vim plugins
rake vim:update        # update vim plugins
rake vim:cleanup       # clean vim plugins
```
