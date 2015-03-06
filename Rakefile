require 'rake'
require 'socket'

IS_MAC = RUBY_PLATFORM.downcase.include?('darwin') && 'mac'

if IS_MAC && File.exist?('/etc/zshenv')
 puts(<<-'WARNING')
 WARNING: Detected /etc/zshenv on OS X

 Vim subshell paths will be messed up unless you do:

 sudo mv /etc/zshenv /etc/zprofile

 Be sure to merge them if zprofile exits!

 See: https://github.com/b4winckler/macvim/wiki/Troubleshooting#rename-the-etczshenv-file-to-etczprofile

 WARNING
end

namespace :submodule do
  desc "init git submodules"
  task :init do
    system 'git submodule update --init --recursive'
  end

  desc "update git submodules to their latest tag"
  task :update => 'submodule:init' do
    system <<-'UPDATE'
      git submodule foreach 'git fetch && git fetch --tags && git checkout $(git describe --tags $(git rev-list --tags --max-count=1))';
      cd Resources/fasd;
      echo 'Install fasd...';
      make install;
    UPDATE
  end
end

namespace :vim do
  desc "install vim plugins"
  task :install do
    exec "vim -u vim/plugs.vim +PlugInstall +qall"
  end
  desc "update vim plugins"
  task :update do
    exec "vim -u vim/plugs.vim +PlugUpdate +qall"
  end
  desc "clean vim plugins"
  task :cleanup do
    exec "vim -u vim/plugs.vim +PlugClean +qall"
  end
end

SKIP_FILES = %w[Resources Rakefile Readme.md config]
HOST = Socket.gethostname.gsub(/\..+$/, '')
VALID_EXTENSIONS = ['conf', 'd', 'local', HOST, IS_MAC].compact

REPO_LOCATION = File.dirname(__FILE__)
DOT_LOCATION  = ENV['HOME']

desc "install .dotfiles into home directory"
task :install do
  install_files
  Dir['config/*'].each do |dir|
    unless File.exist?(dot_file(dir))
      Dir.mkdir(dot_file(dir))
    end
    install_files File.join(dir, '*')
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
task :update => :install do
  delete_files(false, true)
end

def replace_file(file)
  FileUtils.remove_entry_secure dot_file(file), true
  link_file(file)
end

def link_file(file)
  puts_message 'linking', file
  File.symlink repo_file(file), dot_file(file)
end

def valid_file?(file)
  return File.basename(file).match %r(^[^\.]+([\w_.-]*\.(#{VALID_EXTENSIONS.join('|')}))?$)
end

def dot_file(file)
  File.join DOT_LOCATION, ".#{file}"
end

def repo_file(file)
  File.join REPO_LOCATION, file
end

def format_message(verb, file)
  "#{verb} ~/.#{file}"
end

def puts_message(verb, file)
  puts format_message(verb, file)
end

def print_prompt(verb, file)
  print format_message(verb, file), '? [ynaq] '
end

def install_files(dir='*')
  replace_all = false

  Dir[dir].each do |file|
    next if SKIP_FILES.include? file

    unless valid_file?(file)
      puts_message 'ignoring', file
      next
    end

    if File.exist?(dot_file(file))
      if File.identical? file, dot_file(file)
        puts_message 'identical', file
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

def delete_files(implode=false, delete_all=false)
    delete_corrrect_files("#{ENV['HOME']}/.[^.]*", implode, delete_all)
    delete_corrrect_files("#{ENV['HOME']}/.config/*/*", implode, delete_all)
end

def delete_corrrect_files(files, implode, delete_all)
  Dir[files].each do |file_name|
    next unless File.symlink?(file_name)
    target = File.readlink(file_name)
    next unless File.dirname(target).start_with?(File.dirname(__FILE__))
    next unless implode || !File.exist?(target)

    delete_me = false
    unless delete_all
      print_prompt 'delete', file_name
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
      File.delete(file_name)
      puts "deleting #{file_name}"
    else
      puts_message 'skipping', file_name
    end
  end
end

task :default => 'update'
