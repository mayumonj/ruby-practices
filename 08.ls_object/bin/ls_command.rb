# frozen_string_literal: true

require_relative '../lib/argument_parser'
require_relative '../lib/content'
require_relative '../lib/content_factory'
require_relative '../lib/ls'

def main
  argement_parser = ArgumentParser.new(ARGV)
  if argement_parser.error_message
    puts argement_parser.error_message
    return
  end

  ls = Ls.new
  content_factory = ContentFactory.new
  contents, message = content_factory.create_content(argement_parser.path)
  if message
    puts message
    return
  end
  puts ls.display(argement_parser.options, contents)
end

main if __FILE__ == $PROGRAM_NAME
