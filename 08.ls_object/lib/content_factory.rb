# frozen_string_literal: true

# require_relative 'content'

class ContentFactory
  def create_content(path)
    change_directory_to_target(path)
    content_names = Dir.glob('*', File::FNM_DOTMATCH)
    content_names.map do |content_name|
      Content.new(Dir.pwd, content_name)
    end
  end

  private

  def change_directory_to_target(path)
    target_path = path.nil? ? Dir.pwd : path

    return target_path if File.file?(target_path)

    if Dir.exist?(target_path)
      Dir.chdir(target_path)
    else
      throw "ls: #{target_path}: No such file or directory"
    end
  end
end
