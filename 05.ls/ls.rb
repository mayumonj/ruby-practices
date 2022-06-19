# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3
INVALID_OPTION_MESSAGE = 'invalid option'

def main
  options, path, error_message = options_and_path(ARGV)
  puts error_message || get_display_string(options, path)
end

def options_and_path(argv)
  return [nil, nil, nil] if argv[0].nil?
  # aオプション、rオプションのみ受け付ける
  if argv[0][/-(\w)+/]
    return argv[0][/-([ar])+/] ? [argv[0][/-([ar])+/], argv[1], nil] : [nil, nil, INVALID_OPTION_MESSAGE]
  end

  [nil, argv[0], nil]
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
  get_display_columns(contents) unless contents.empty?
end

def get_contents(options)
  contents = Dir.glob('*')
  return contents if options.nil?

  contents = Dir.glob('*', File::FNM_DOTMATCH) if options.include? 'a'
  contents.reverse! if options.include? 'r'
  contents
end

def get_display_columns(contents)
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
