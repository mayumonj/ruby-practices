# frozen_string_literal: true

require 'optparse'

class ArgumentParser
  attr_reader :options, :path, :error_message

  def initialize(argv)
    opt = OptionParser.new

    options = {}
    opt.on('-a') { |v| options[:a] = v }
    opt.on('-r') { |v| options[:r] = v }
    opt.on('-l') { |v| options[:l] = v }

    begin
      @options = options
      @path = opt.parse!(argv).first
    rescue OptionParser::InvalidOption => e
      @error_message = e.message
    end
  end
end
