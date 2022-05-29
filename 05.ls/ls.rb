# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3

def main
  target_path = ARGV[0].nil? ? Dir.pwd : ARGV[0]

  if File.file?(target_path)
    puts ARGV[0]
    exit
  end

  begin
    Dir.chdir(target_path)
  rescue Errno::ENOENT => e
    puts e
    exit
  end

  content_names = Dir.glob('*')
  display_filenames(content_names) unless content_names.empty?
end

def display_filenames(content_names)
  padding = get_padding(content_names)
  number_of_rows = (content_names.length / NUMBER_OF_COLUMNS.to_f).ceil
  (0..number_of_rows - 1).each do |n|
    (0..content_names.length - 1).each do |i|
      print content_names[i].ljust(padding) if i % number_of_rows == n
    end
    print "\n"
  end
end

def get_padding(content_names)
  [DEFAULT_PADDING, content_names.map(&:length).max].max + DEFAULT_BUFFER
end

main if __FILE__ == $PROGRAM_NAME
