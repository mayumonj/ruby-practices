# frozen_string_literal: true

require_relative 'content'

class ContentFactory
  def self.create_contents(path = nil)
    target_path = path.nil? ? Dir.pwd : path
    contents = []
    if File.file?(target_path)
      contents << Content.new(target_path)
    elsif File.directory?(target_path)
      Dir.foreach(target_path) do |name|
        contents << Content.new("#{target_path}/#{name}")
      end
    else
      raise ArgumentError, "ls: #{target_path}: No such file or directory"
    end

    contents
  end
end
