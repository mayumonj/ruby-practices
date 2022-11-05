# frozen_string_literal: true

require 'etc'

class Content
  attr_reader :name, :ftype, :permission, :nlink, :owner, :group, :size, :mtime, :blocks

  def initialize(filepath)
    fs = File.lstat(filepath)
    name = filepath.split('/').last
    @name = name
    @ftype = fs.ftype
    @permission = fs.mode.to_s(8)
    @nlink = fs.nlink
    @owner = Etc.getpwuid(fs.uid).name
    @group = Etc.getgrgid(fs.gid).name
    @size = fs.size
    @mtime = fs.mtime
    @blocks = fs.blocks
  end

  def dot_file?
    @name[0] == '.'
  end
end
