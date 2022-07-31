# frozen_string_literal: true

require 'etc'
require 'optparse'

NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3

PERMISSON_STRING = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FILE_TYPE_STRING = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

def main
  options, path, error_message = options_and_path(ARGV)
  puts error_message || get_display_string(options, path)
end

def options_and_path(argv)
  opt = OptionParser.new

  options = {}

  # aオプション、rオプション、lオプションのみ受け付ける
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }

  begin
    [options, opt.parse!(argv).first, nil]
  rescue OptionParser::InvalidOption => e
    [nil, nil, e]
  end
end

def get_display_string(options, path)
  target_path = path.nil? ? Dir.pwd : path

  return target_path if File.file?(target_path)

  begin
    Dir.chdir(target_path)
  rescue Errno::ENOENT => e
    return e
  end

  rows(options)
end

def rows(options)
  if !options.nil? && options.key?(:l)
    contents = get_content_details(options)
    return get_details_display_rows(contents) unless contents.empty?
  else
    contents = get_content_names(options)
    return get_display_rows(contents) unless contents.empty?
  end
end

def get_content_details(options)
  contents = get_content_names(options)
  contents.map do |content_name|
    detail = {}
    fs = File.lstat("#{Dir.pwd}/#{content_name}")
    detail[:name] = content_name
    detail[:ftype] = fs.ftype
    detail[:permission] = fs.mode.to_s(8)
    detail[:nlink] = fs.nlink
    detail[:owner] = Etc.getpwuid(fs.uid).name
    detail[:group] = Etc.getgrgid(fs.gid).name
    detail[:size] = fs.size
    detail[:mtime] = fs.mtime
    detail[:blocks] = fs.blocks
    detail
  end
end

def get_content_names(options)
  contents = Dir.glob('*')
  return contents if options.nil?

  contents = Dir.glob('*', File::FNM_DOTMATCH) if options.key?(:a)
  contents.reverse! if options.key?(:r)
  contents
end

def get_details_display_rows(content_details)
  max_lengths = max_lengths(content_details)
  rows = []
  rows[0] = "total #{content_details.inject(0) { |total, content| total + content[:blocks] }}"
  content_details.each do |content|
    row = []
    row << "#{file_type_string(content[:ftype])}#{file_permission_strings(content[:permission])}"
    row << content[:nlink].to_s.rjust(max_lengths[:nlink])
    row << content[:owner].rjust(max_lengths[:owner])
    row << content[:group].rjust(max_lengths[:group])
    row << content[:size].to_s.rjust(max_lengths[:size])
    row << format_mtime(content[:mtime])
    row << content[:name]
    rows << row.join('  ')
  end
  rows
end

def max_lengths(content_details)
  max_lengths = {}
  max_lengths[:nlink] = content_details.inject(0) { |max, content| [max, content[:nlink].to_s.length].max }
  max_lengths[:owner] = content_details.inject(0) { |max, content| [max, content[:owner].to_s.length].max }
  max_lengths[:group] = content_details.inject(0) { |max, content| [max, content[:group].to_s.length].max }
  max_lengths[:size] = content_details.inject(0) { |max, content| [max, content[:size].to_s.length].max }
  max_lengths
end

def format_mtime(mtime)
  if mtime.strftime('%Y').to_i == Time.now.year
    mtime.strftime('%m %d %H:%M')
  else
    mtime.strftime('%m %d  %Y')
  end
end

def file_type_string(ftype)
  FILE_TYPE_STRING[ftype]
end

def file_permission_strings(permission)
  "#{PERMISSON_STRING[permission[-3]]}#{PERMISSON_STRING[permission[-2]]}#{PERMISSON_STRING[permission[-1]]}"
end

def get_display_rows(contents)
  padding = get_padding(contents)
  number_of_rows = (contents.length / NUMBER_OF_COLUMNS.to_f).ceil
  rows = []
  (0..number_of_rows - 1).each do |n|
    row = []
    (0..contents.length - 1).each do |i|
      row << contents[i].ljust(padding) if i % number_of_rows == n
    end
    rows << row.join
  end
  rows
end

def get_padding(contents)
  [DEFAULT_PADDING, contents.map(&:length).max].max + DEFAULT_BUFFER
end

main if __FILE__ == $PROGRAM_NAME
