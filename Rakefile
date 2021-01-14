require 'rake'
require_relative 'helpers'

STDOUT.sync = true
VI_BIN = `which nvim || which vim || which vi`.chomp

namespace :submodule do
  desc 'init git submodules'
  task :init do
    system 'git submodule update --init --recursive'
  end

  desc 'update git submodules to their latest master'
  task update: 'submodule:init' do
    system 'git submodule update --remote'
  end
end

namespace :fzf do
  desc 'install fzf'
  task :install do
    system <<-'UPDATE'
      cd Resources/fzf;
      echo 'Install fzf...';
      yes | ./install --xdg --no-update-rc
    UPDATE
  end
end

namespace :vim do
  desc 'install vim plugins'
  task :install do
    system "#{VI_BIN} -u config/nvim/plugs.vim -es +PlugInstall"
  end
  desc 'update vim plugins'
  task :update do
    system "#{VI_BIN} -u config/nvim/plugs.vim -es +PlugUpdate"
  end
  desc 'clean vim plugins'
  task :cleanup do
    system "#{VI_BIN} -u config/nvim/plugs.vim -es +PlugClean"
  end
end


ALIAS_MAPPING = {
  dot_file('vim') => dot_file('config/nvim'),
  dot_file('vimrc') => dot_file('config/nvim/init.vim'),
  dot_file('config/nvim/autoload/plug.vim') =>
    File.expand_path('Resources/vim-plug/plug.vim')
}

desc 'install .dotfiles into home directory'
task :install do
  Dir.chdir('home') { install_files Dir['*'] }
  install_directory('config')
end

desc 'make dot file symlinks'
task :make_alias_links do
  replace_all = false
  ALIAS_MAPPING.each_pair do |link, target|
    if File.exist?(link) || File.symlink?(link)
      if File.identical? target, link
        puts_message '', link
        next
      else
        replace_me, replace_all =
          delete_prompt(link, replace_all, prompt = 'replac%s')

        if replace_me || replace_all
          FileUtils.remove_entry_secure link, true
        else
          next
        end
      end
    else
      puts_message 'linking', link
    end

    mkdir_p(File.dirname(link))
    File.symlink target, link
  end
end

desc 'clean up .dotfile symlinks that are no longer there'
task :cleanup do
  delete_files
end

desc 'remove all .dotfile symlinks'
task :implode do
  delete_files(true)
end

desc 'install new and remove old symlinks'
task update: %i[install make_alias_links] do
  delete_files(false, true)
end

desc 'first 12 characters of a sha2 digest of the non-fully-qualified hostname'
task :hostname do
  puts HOST
end

desc 'Initialize new dotfiles install'
task init: %i[submodule:init submodule:update vim:install fzf:install install]

desc 'Update submodules, vim, and fzf'
task upgrade: %i[submodule:update vim:update fzf:install]

task default: 'update'
