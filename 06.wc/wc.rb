# frozen_string_literal: true

require 'optparse'

DEFAULT_SPACE = 8

def main
  options, files, error_message = parse_arguments(ARGV)
  puts error_message || build_display_text(options, files)
end

def parse_arguments(argv)
  opt = OptionParser.new

  options = {}

  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }

  begin
    [options, opt.parse!(argv), nil]
  rescue OptionParser::InvalidOption => e
    [nil, nil, e.message]
  end
end

def build_display_text(options, files)
  if files.empty?
    text = read_stdin
    counts = [count_words(text, nil)]
  else
    counts = files.map do |file|
      text = File.open(file, 'r').read
      count_words(text, file)
    rescue StandardError => e
      {
        lines: 0,
        words: 0,
        characters: 0,
        error: e.message
      }
    end
    counts << calculate_total(counts) if files.length > 1
  end
  format_counts(counts, options)
end

def read_stdin
  text = []
  while (str = $stdin.gets)
    text << str
  end
  text.join
end

def count_words(text, file)
  {
    lines: text.count("\n"),
    words: text.split.length,
    characters: text.length,
    file_path: file
  }
end

def calculate_total(counts)
  {
    lines: counts.sum { |count| count[:lines] },
    words: counts.sum { |count| count[:words] },
    characters: counts.sum { |count| count[:characters] },
    file_path: 'total'
  }
end

def format_counts(counts, options)
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
