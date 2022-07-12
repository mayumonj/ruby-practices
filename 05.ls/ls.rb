# frozen_string_literal: true

require 'optparse'

NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3

def main
  options, path, error_message = options_and_path(ARGV)
  puts error_message || get_display_string(options, path)
end

def options_and_path(argv)
  opt = OptionParser.new

  options = {}

  # aオプション、rオプションのみ受け付ける
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }

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

  contents = get_contents(options)
  get_display_rows(contents) unless contents.empty?
end

def get_contents(options)
  contents = Dir.glob('*')
  return contents if options.nil?

  contents = Dir.glob('*', File::FNM_DOTMATCH) if options.key?(:a)
  contents.reverse! if options.key?(:r)
  contents
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
