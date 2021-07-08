# What? More Dotfiles?!

## Taskfile

Uses [Taskfile](https://github.com/adriancooney/Taskfile) for running tasks, once the fish config is in place there is an alias for `run` to `./Taskfile`

    ./Taskfile <task> <args>
    Tasks:
         1	autocleanup         # clean up stale symlinks that point to .dotfiles/ without prompting
         2	cleanup             # clean up stale symlinks that point to .dotfiles/
         3	homebrew:bundle     # install all brews in Brewfile
         4	homebrew:install    # install homebrew itself
         5	hostname            # print hash of hostname
         6	implode             # remove all symlinks that point to .dotfiles/ without asking
         7	init                # do initial tasks for new install
         8	install             # create symlinks for .dotfiles/home and ./dotfiles/config
         9	make_alias_links    # create symlinks from aliases.json file, see below
        10	submodule:init      # initialize all git submodules
        11	submodule:update    # update all git submodules to their latest of the branch they're tracking
        12	update              # create all symlinks and clean up stale ones
        13	upgrade             # update submodules and vi
        14	vi:cleanup          # Ask `vim-plug` to clean plugins
        15	vi:install          # Ask `vim-plug` to install plugins
        16	vi:update           # Ask `vim-plug` to update plugins

    default task:
    {
        update
    }

## Config Order

Notes:
*  `hostname` below is the output of the `run hostname` task.
* `_platform` files are only loaded if they're `_mac` or `_linux` prefixed files on the correct platform.
* `*local`* is git ignored so local overrides can be made that won't be git tracked like the above two options.

* nvim
    1. plugs.vim
    1. _platform.plugs.vim
    1. _`hostname`.plugs.vim
    1. local.plugs.vim
    1. init.vim
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

## Resources/aliases.json

Format of file:

    {
      "vim": "~/.config/nvim",
      "vimrc": "~/.config/nvim/init.vim",
      "config/nvim/autoload/plug.vim": "./Resources/vim-plug/plug.vim"
    }

Key is the name of the dotfile to create, will be placed in home
directory and prefixed with . automatically

Value is the target the symlink should point to, a leading ~ will be expanded to
home

## Thanks

Thanks to [ryanb](https://github.com/ryanb/dotfiles) for the starting point.
Thanks to [adriancooney](https://github.com/adriancooney/Taskfile) for the Taskfile format.
