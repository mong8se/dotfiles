require 'rake'
require 'erb'
require 'socket'

namespace :submodule do
  desc "init git submodules"
  task :init do
    system 'git submodule update --init --recursive'
    Rake::Task['submodule:update'].invoke
  end

  desc "update git submodules to their latest tag"
  task :update do
    system <<-'UPDATE'
      git submodule foreach 'git fetch && git fetch --tags && git checkout $(git describe --tags $(git rev-list --tags --max-count=1))';
      cd Resources/fasd;
      echo 'Need sudo to install fasd...';
      sudo make install;
    UPDATE
  end
end

namespace :vim do
  desc "install vim plugins"
  task :install do
    exec "MYVIMRC=vim/vimrc vim -u vim/vimrc.plug +PlugInstall +qall"
  end
  desc "update vim plugins"
  task :update do
    exec "MYVIMRC=vim/vimrc vim -u vim/vimrc.plug +PlugUpdate +qall"
  end
end

SKIP_FILES = %w[Resources Rakefile]
HOST = Socket.gethostname.gsub(/\..+$/, '')
VALID_EXTENSIONS = ['erb', 'conf', 'd', 'local', HOST, RUBY_PLATFORM.downcase.include?('darwin') ? 'mac' : nil ].compact
VALID = %r(^[^\.]+([\w_.-]*\.(#{VALID_EXTENSIONS.join('|')}))?$)

REPO_LOCATION = File.dirname(__FILE__)
DOT_LOCATION  = ENV['HOME']

desc "install .dotfiles into home directory"
task :install do
  replace_all = false

  Dir['*'].each do |file|
    next if SKIP_FILES.include? file
    unless file.match VALID
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

desc 'clean up .dotfile symlinks that are no longer there'
task :cleanup do
  delete_files
end

desc 'remove all .dotfile symlinks'
task :implode do
  delete_files(true)
end

def replace_file(file)
  FileUtils.remove_entry_secure dot_file(file), true
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts_message 'generating', file
    File.open(dot_file(file), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts_message 'linking', file
    File.symlink repo_file(file), dot_file(file)
  end
end

def name(file)
    file.sub('.erb', '')
end

def dot_file(file)
  File.join DOT_LOCATION, ".#{name(file)}"
end

def repo_file(file)
  File.join REPO_LOCATION, File.basename(file).sub(/^\./,'')
end

def format_message(verb, file)
  "#{verb} ~/.#{name(file)}"
end

def puts_message(verb, file)
  puts format_message(verb, file)
end

def print_prompt(verb, file)
  print format_message(verb, file), '? [ynaq] '
end

def delete_files(implode=false)
  delete_all = false

  Dir["#{ENV['HOME']}/.[^.]*"].each do |file_name|
    next unless File.symlink?(file_name) && File.dirname(__FILE__) == File.dirname(File.readlink(file_name))
    next unless implode || !File.exist?(repo_file(file_name))

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
