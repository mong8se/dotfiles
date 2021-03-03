require 'rake'
require_relative 'helpers'

STDOUT.sync = true
VI_BIN = `which nvim || which vim || which vi`.chomp

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

desc 'clean up .dotfile symlinks that are no longer there without prompting'
task :autocleanup do
  delete_files(false, true)
end

desc 'remove all .dotfile symlinks'
task :implode do
  delete_files(true)
end
