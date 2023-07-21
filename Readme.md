# What? More Dotfiles?! -- NOW CONFIG FREE!    

No configuration necessary dotfile management, just files and folder and
(new!) symlinks in the appropriate tree shape.

## Taskfile

Uses [Taskfile](https://github.com/adriancooney/Taskfile) for running tasks, once the fish config is in place there is an alias for `run` to `./Taskfile`

    ./Taskfile <task> <args>

    Tasks:
        autocleanup      | Clean up stale symlinks that point to .dotfiles/ without prompting
        cleanup          | Clean up stale symlinks that point to .dotfiles/
        deno:install     | Install Deno
        deno:upgrade     | Upgrade Deno
        describe         | Prints description of task
        explain          | Prints definition of task
        help             | Prints this help
        homebrew:bundle  | Install homebrew bundle
        homebrew:install | Install homebrew
        hostname         | Print hash of hostname
        implode          | Remove all symlinks that point to .dotfiles/ without asking
        init             | Bootstrap a new install
        install          | Install symlinks to .dotfiles/home
        lom:install      | Install link_o_matic via cargo
        os:upgrade       | Upgrade OS
        submodule:init   | Init git submodules
        submodule:update | Update your submodules
        sync             | Install and cleanup symlinks to .dotfiles/home
        test             | 
        upgrade          | Upgrade links, os, submodules, and vi
        vi:cleanup       | Clean up Lazy plugins for neovim
        vi:install       | Install Lazy plugins for neovim
        vi:sync          | Sync Lazy plugins for neovim

    default => {
        task:sync
    }

## Config Order

Notes:
*  `hostname` below is the output of the `run hostname` task.
* `_platform` files are only loaded if they're `_mac` or `_linux` prefixed files on the correct platform.
* `*local*` is git ignored so local overrides can be made that won't be git tracked like the above two options.

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

## Aliases (symlinks to spawn symlinks)

If you create a symlink inside `.dotfiles` that is a valid _relative_ path
to a file inside `.dotfiles`, when the link is created it will point
directly to the target of the symlink, not the intermediary symlink.

For example start in your dot files:

    cd ~/.dotfiles

This step isn't strictly necessary but will allow tab completion of your
target

    cd home

Now make a relative link to your target file (you'd link to `home/vimrc` if
you skipped above step)

    ln -s ../config/nvim/init.vim vimrc

Now you will have a symlink in `.dotfiles/home/vimrc` that points to
`.dotfiles/config/nvim/init.vim` but relatively.

When you run install your `~/.vimrc` will point to your
`.dotfiles/config/nvim/init.vim` ... not to the symlink `.dotfiles/home/vimrc`

## Thanks

Thanks to [ryanb](https://github.com/ryanb/dotfiles) for the starting point.
Thanks to [adriancooney](https://github.com/adriancooney/Taskfile) for the Taskfile format.
