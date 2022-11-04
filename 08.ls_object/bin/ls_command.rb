# frozen_string_literal: true

require_relative '../lib/argument_parser'
require_relative '../lib/content_factory'
require_relative '../lib/ls'

def main
  argument_parser = ArgumentParser.new(ARGV)
  if argument_parser.error_message
    puts argument_parser.error_message
    return
  end

  content_factory = ContentFactory.new
  contents, message = content_factory.create_content(argument_parser.path)
  if message
    puts message
    return
  end
  ls = Ls.new
  ls.display(argument_parser.options, contents)
end

main if __FILE__ == $PROGRAM_NAME
