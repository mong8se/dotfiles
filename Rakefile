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
VALID_EXTENSIONS = ['erb', 'd', 'local', HOST, RUBY_PLATFORM.downcase.include?('darwin') ? 'mac' : nil ].compact
VALID = %r(^[^\.]+([\w_.-]*\.(#{VALID_EXTENSIONS.join('|')}))?$)

desc "install the dot files into user's home directory"
task :install do
  replace_all = false

  Dir['*'].each do |file|
    next if SKIP_FILES.include? file
    next unless file.match VALID

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end
