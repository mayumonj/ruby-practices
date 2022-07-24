# frozen_string_literal: true

require 'optparse'

DEFAULT_SPACE = 8

def main
  options, files, error_message = options_and_files(ARGV)
  puts error_message || get_display_string(options, files)
end

def options_and_files(argv)
  opt = OptionParser.new

  options = {}

  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }

  begin
    [options, opt.parse!(argv), nil]
  rescue OptionParser::InvalidOption => e
    [nil, nil, e]
  end
end

def get_display_string(options, files)
  if files.empty?
    stdin_text = []
    while (str = $stdin.gets)
      stdin_text << str
    end
    counts = [word_count(stdin_text.join, nil)]
  else
    counts = files.map do |file|
      word_count(read_file(file), file)
    end
    counts << total(counts) if files.length > 1
  end
  format(counts, options)
end

def read_file(file)
  File.open(file, 'r').read
rescue StandardError => e
  e
end

def word_count(text, file)
  count = {}
  if text.instance_of?(String)
    count[:lines] = text.count("\n")
    count[:words] = text.split.length
    count[:characters] = text.length
    count[:file_path] = file unless file.nil?
  else
    error = text
    count[:error] = error.message
  end
  count
end

def total(counts)
  total_count = {}
  total_count[:lines] = counts.inject(0) { |total, count| total + (count[:lines] || 0) }
  total_count[:words] = counts.inject(0) { |total, count| total + (count[:words] || 0) }
  total_count[:characters] = counts.inject(0) { |total, count| total + (count[:characters] || 0) }
  total_count[:file_path] = 'total'
  total_count
end

def format(counts, options)
  options = { l: true, w: true, c: true } if options.empty?
  counts.map do |count|
    if count[:error].nil?
      format_item(options, count)
    else
      count[:error]
    end
  end
end

def format_item(options, count)
  row = []
  row << count[:lines].to_s.rjust(DEFAULT_SPACE) if options.key?(:l)
  row << count[:words].to_s.rjust(DEFAULT_SPACE) if options.key?(:w)
  row << count[:characters].to_s.rjust(DEFAULT_SPACE) if options.key?(:c)
  row << count[:file_path] unless count[:file_path].nil?
  row.join(' ')
end

main if __FILE__ == $PROGRAM_NAME
