# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3

def main
  if ARGV[0] == '-a'
    puts get_display_string('-a', ARGV[1])
  else
    puts get_display_string('', ARGV[0])
  end
end

def get_display_string(option, arg_string)
  target_path = arg_string.nil? ? Dir.pwd : arg_string

  return target_path if File.file?(target_path)

  begin
    Dir.chdir(target_path)
  rescue Errno::ENOENT => e
    return e
  end

  case option
  when ''
    content_names = Dir.glob('*')
  when '-a'
    content_names = Dir.glob('*', File::FNM_DOTMATCH)
  end
  get_display_columns(content_names) unless content_names.empty?
end

def get_display_columns(content_names)
  padding = get_padding(content_names)
  number_of_rows = (content_names.length / NUMBER_OF_COLUMNS.to_f).ceil
  rows = []
  (0..number_of_rows - 1).each do |n|
    row = []
    (0..content_names.length - 1).each do |i|
      row << content_names[i].ljust(padding) if i % number_of_rows == n
    end
    rows << row.join
  end
  rows
end

def get_padding(content_names)
  [DEFAULT_PADDING, content_names.map(&:length).max].max + DEFAULT_BUFFER
end

main if __FILE__ == $PROGRAM_NAME
