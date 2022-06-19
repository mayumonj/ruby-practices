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

  contents_list = get_contents_list(options)
  get_display_columns(contents_list) unless contents_list.empty?
end

def get_contents_list(options)
  contents_list = Dir.glob('*')
  return contents_list if options.nil?

  contents_list = Dir.glob('*', File::FNM_DOTMATCH) if options.include? 'a'
  contents_list.reverse! if options.include? 'r'
  contents_list
end

def get_display_columns(contents_list)
  padding = get_padding(contents_list)
  number_of_rows = (contents_list.length / NUMBER_OF_COLUMNS.to_f).ceil
  rows = []
  (0..number_of_rows - 1).each do |n|
    row = []
    (0..contents_list.length - 1).each do |i|
      row << contents_list[i].ljust(padding) if i % number_of_rows == n
    end
    rows << row.join
  end
  rows
end

def get_padding(contents_list)
  [DEFAULT_PADDING, contents_list.map(&:length).max].max + DEFAULT_BUFFER
end

main if __FILE__ == $PROGRAM_NAME
