NUMBER_OF_COLUMNS = 3
DEFAULT_PADDING = 25
DEFAULT_BUFFER = 3

def main
  target_path = ARGV[0].nil? ? __dir__ : ARGV[0]

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

  file_names = Dir.glob('*')
  display_filenames(file_names)
end

def display_filenames(file_names)
  padding = get_padding(file_names)
  number_of_rows = (file_names.length / NUMBER_OF_COLUMNS.to_f).ceil
  (0..number_of_rows - 1).each do |n|
    (0..file_names.length - 1).each do |i|
      print file_names[i].ljust(padding) if i % number_of_rows == n
    end
    print "\n"
  end
end

def get_padding(file_names)
  padding = DEFAULT_PADDING
  file_names.each do |file_name|
    padding = [file_name.length, padding].max
  end
  padding + DEFAULT_BUFFER
end

main if __FILE__ == $PROGRAM_NAME
