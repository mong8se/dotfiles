require 'digest/md5'
require 'socket'

PLATFORM =
  if RUBY_PLATFORM.downcase.include?('darwin')
    'mac'
  elsif RUBY_PLATFORM.downcase.include?('linux')
    'linux'
  else
    'unknown'
  end

REPO_LOCATION = File.dirname(__FILE__)
DOT_LOCATION = ENV['HOME']
HOST =
  Digest::MD5.hexdigest(Socket.gethostname.gsub(/\..+$/, '')).to_i(16).to_s(36)
    .slice(0, 12)

def dot_basename(file)
  '.' + file.sub(/_#{HOST}\b/, '_machine').sub(/_#{PLATFORM}\b/, '_platform')
end

def dot_file(file)
  # Determine destination name
  # replace hostname sha with word 'machine'
  File.join DOT_LOCATION, dot_basename(file)
end

def install_directory(dir)
  mkdir(dot_file(dir)) unless File.exist?(dot_file(dir))
  install_files File.join(dir, '*'), true
end

def replace_file(file)
  FileUtils.remove_entry_secure dot_file(file), true
  link_file(file)
end

def link_file(file)
  puts_message 'linking', file
  File.symlink File.expand_path(file), dot_file(file)
end

def is_invalid_file_for_target?(file)
  file_name = File.basename(file)
  return file_name.match(/^_(?!#{HOST}|#{PLATFORM})/)
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
        puts_message '', file
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
      ["#{DOT_LOCATION}/.[^.]*", "#{DOT_LOCATION}/.config/**/*"],
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
