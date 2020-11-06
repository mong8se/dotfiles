require 'rake'
require 'socket'
require 'digest/md5'

IS_MAC = RUBY_PLATFORM.downcase.include?('darwin')

if IS_MAC && File.exist?('/etc/zshenv')
  puts(<<-'WARNING')
 WARNING: Detected /etc/zshenv on OS X

 Vim subshell paths will be messed up unless you do:

 sudo mv /etc/zshenv /etc/zprofile

 Be sure to merge them if zprofile exits!

 See: https://github.com/b4winckler/macvim/wiki/Troubleshooting#rename-the-etczshenv-file-to-etczprofile

 WARNING
end

VI_BIN = `which nvim || which vim || which vi`.chomp

namespace :submodule do
  desc 'init git submodules'
  task :init do
    system 'git submodule update --init --recursive'
  end

  desc 'update git submodules to their latest master'
  task update: 'submodule:init' do
    system <<-'UPDATE'
      git submodule update --remote;
      cd ../fzf;
      echo 'Install fzf...';
      yes | ./install
    UPDATE
  end
end

namespace :vim do
  desc 'install vim plugins'
  task :install do
    exec "#{VI_BIN} -u config/nvim/plugs.vim +PlugInstall +qall"
  end
  desc 'update vim plugins'
  task :update do
    exec "#{VI_BIN} -u config/nvim/plugs.vim +PlugUpdate +qall"
  end
  desc 'clean vim plugins'
  task :cleanup do
    exec "#{VI_BIN} -u config/nvim/plugs.vim +PlugClean +qall"
  end
end

REPO_LOCATION = File.dirname(__FILE__)
DOT_LOCATION = ENV['HOME']

def dot_basename(file)
  ".#{file.sub(HOST, 'machine')}"
end

def dot_file(file)
  # Determine destination name
  # replace hostname sha with word 'machine'
  File.join DOT_LOCATION, dot_basename(file)
end

def repo_file(file)
  File.join REPO_LOCATION, file
end

SKIP_FILES = %w[Resources Rakefile Readme.md config]
HOST =
  Digest::MD5.hexdigest(Socket.gethostname.gsub(/\..+$/, '')).to_i(16).to_s(36)
    .slice(0, 12)

ALIAS_MAPPING = {
  dot_file('vim') => dot_file('config/nvim'),
  dot_file('vimrc') => dot_file('config/nvim/init.vim'),
  dot_file('config/nvim/autoload/plug.vim') =>
    repo_file('Resources/vim-plug/plug.vim'),
  '/usr/local/bin/fasd' => repo_file('Resources/fasd/fasd'),
  '/usr/local/share/man/man1/fasd.1' => repo_file('Resources/fasd/fasd.1')
}

desc 'install .dotfiles into home directory'
task :install do
  install_files Dir['*'].reject { |file| SKIP_FILES.include? file }
  install_files Dir['config/*'].reject { |file| File.directory?(file) }
  Dir['config/*'].each { |dir| install_directory(dir) }
end

desc 'make dot file symlinks'
task :make_alias_links do
  replace_all = false
  ALIAS_MAPPING.each_pair do |link, target|
    if File.exist?(link) || File.symlink?(link)
      if File.identical? target, link
        puts_message '>', link
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

def install_directory(dir)
  Dir.mkdir(dot_file(dir)) unless File.exist?(dot_file(dir))
  install_files File.join(dir, '*'), true
end

def replace_file(file)
  FileUtils.remove_entry_secure dot_file(file), true
  link_file(file)
end

def link_file(file)
  puts_message 'linking', file
  File.symlink repo_file(file), dot_file(file)
end

def is_invalid_file_for_target?(file)
  file_name = File.basename(file)
  return(
    (!IS_MAC && file_name.match(/^mac\.|\.mac$/)) ||
      file_name.match(/^_(?!#{HOST})/)
  )
end

def format_message(verb, file)
  "#{verb.rjust(9, ' ')} #{file.start_with?('/') ? file : dot_basename(file)}"
end

def puts_message(verb, file)
  puts format_message(verb, file)
end

def print_prompt(verb, file)
  print format_message(verb, file), '? [ynaq] '
end

def install_files(dir = '*', recurse = false)
  replace_all = false

  Dir.glob(dir).each do |file|
    if is_invalid_file_for_target?(file)
      puts_message 'ignoring', file
      next
    end

    if recurse && File.directory?(file)
      install_directory(file)
    elsif File.symlink?(dot_file(file)) || File.exist?(dot_file(file))
      if File.identical? file, dot_file(file)
        puts_message '>', file
      elsif replace_all
        replace_file(file)
      else
        print_prompt 'overwrite', file
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts_message 'skipping', file
        end
      end
    else
      link_file(file)
    end
  end
end

def delete_files(implode = false, delete_all = false)
  delete_all =
    delete_correct_files(
      ["#{ENV['HOME']}/.[^.]*", "#{ENV['HOME']}/.config/**/*"],
      implode,
      delete_all
    ) { |target| File.dirname(target).start_with?(REPO_LOCATION) }
  ALIAS_MAPPING.each do |file_name, correct_target|
    delete_correct_files(file_name, implode, delete_all) do |target|
      target == correct_target
    end
  end
end

def delete_correct_files(files, implode, delete_all)
  Dir.glob(files).each do |file_name|
    next unless File.symlink?(file_name)
    target = File.readlink(file_name)
    next unless yield target
    unless implode || !File.exist?(target) ||
             is_invalid_file_for_target?(target)
      next
    end

    delete_me, delete_all = delete_prompt(file_name, delete_all)

    if delete_me || delete_all
      File.delete(file_name)
      dir_name = File.dirname(file_name)

      if Dir.entries(dir_name).length == 2
        delete_me_dir, delete_all_dir =
          delete_prompt(dir_name, delete_all, 'remov%s empty directory')
        Dir.rmdir(dir_name) if delete_me_dir || delete_all_dir
      end
    end
  end

  return delete_all
end

def delete_prompt(file_name, delete_all, prompt = 'delet%s')
  delete_me = false
  unless delete_all
    print_prompt prompt % 'e', file_name
    case $stdin.gets.chomp
    when 'y'
      delete_me = true
    when 'q'
      exit
    when 'a'
      delete_all = true
    end
  end

  if delete_me || delete_all
    puts_message prompt % 'ing', file_name
  else
    puts_message 'skipping', file_name
  end

  return delete_me, delete_all
end

# https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
desc 'Install profile for iterm2 italics support'
task 'xterm-italic' do
  system 'tic Resources/xterm-italic/xterm-256color-italic.terminfo'
  puts "Set your term to 'xterm-256color-italic'"
end

task default: 'update'
