#!/usr/bin/env ruby
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

  argument_parser.paths << '.' if argument_parser.paths.empty?

  argument_parser.paths.each do |path|
    begin
      contents = ContentFactory.create_contents(path)
    rescue ArgumentError => e
      puts e.message
      next
    end
    puts "#{path}:" if argument_parser.paths.size > 1
    Ls.display(argument_parser.options, contents)
    puts '' if argument_parser.paths.size > 1
  end
end

main if __FILE__ == $PROGRAM_NAME
