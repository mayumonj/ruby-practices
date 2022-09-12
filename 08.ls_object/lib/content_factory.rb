# frozen_string_literal: true

# require_relative 'content'

class ContentFactory
  def create_content(path)
    target_path = path.nil? ? Dir.pwd : path
    return [nil, target_path] if File.file?(target_path)

    begin
      Dir.chdir(target_path)
    rescue Errno::ENOENT
      return [nil, "ls: #{target_path}: No such file or directory"]
    end

    content_names = Dir.glob('*', File::FNM_DOTMATCH)
    contents = content_names.map do |content_name|
      Content.new(Dir.pwd, content_name)
    end
    [contents, nil]
  end
end
