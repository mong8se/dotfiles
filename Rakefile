require 'rake'
require 'erb'
require 'socket'

desc "init git subodules"
task :init_submodules do
    `git submodule update --init`
    `cd Resources/fasd; sudo make install`
end

desc "update git submodules"
task :update_submodules do
    `git submodule foreach 'git checkout master && git pull'`
end

desc "install vim bundles"
task :vundle do
    puts "Run this command:"
    puts "vim -u ~/.vimrc.vundle +PluginInstall! +q"
end

SKIP_FILES = %w[Resources Rakefile]
HOST = Socket.gethostname.gsub(/\..+$/, '')
VALID_EXTENSIONS = ['erb', 'conf', 'd', 'local', HOST, RUBY_PLATFORM.downcase.include?('darwin') ? 'mac' : nil ].compact
VALID = %r(^[^\.]+([\w_.-]*\.(#{VALID_EXTENSIONS.join('|')}))?$)

desc "install the dot files into user's home directory"
task :install do
  replace_all = false

  Dir['*'].each do |file|
    next if SKIP_FILES.include? file
    unless file.match VALID
      puts "ignoring ~/.#{name(file)}"
      next
    end

    if File.exist?(File.join(ENV['HOME'], ".#{name(file)}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{name(file)}")
        puts "identical ~/.#{name(file)}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{name(file)}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{name(file)}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{name(file)}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{name(file)}"
    File.open(File.join(ENV['HOME'], ".#{name(file)}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def name(file)
    file.sub('.erb', '')
end
