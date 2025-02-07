# frozen_string_literal: true

class Ls
  NUMBER_OF_COLUMNS = 3
  DEFAULT_BUFFER = 2

  PERMISSON_STRING = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  FILE_TYPE_STRING = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  def self.display(options, contents)
    contents.reject!(&:dot_file?) unless options.key?(:a)
    contents.reverse! if options.key?(:r)
    return if contents.empty?

    list = if options.key?(:l)
             generate_detail_list(contents)
           else
             generate_simple_list(contents)
           end
    puts list
    list
  end

  def self.generate_detail_list(contents)
    max_lengths = calculate_max_lengths(contents)
    rows = []
    rows[0] = "total #{contents.inject(0) { |total, content| total + content.blocks }}"
    contents.each do |content|
      row = []
      row << "#{file_type_string(content.ftype)}#{file_permission_strings(content.permission)}"
      row << content.nlink.to_s.rjust(max_lengths[:nlink])
      row << content.owner.rjust(max_lengths[:owner])
      row << content.group.rjust(max_lengths[:group])
      row << content.size.to_s.rjust(max_lengths[:size])
      row << format_mtime(content.mtime)
      row << content.display_name
      rows << row.join(' ' * DEFAULT_BUFFER)
    end
    rows
  end

  def self.generate_simple_list(contents)
    padding = calculate_max_lengths(contents)[:display_name] + DEFAULT_BUFFER
    number_of_rows = (contents.length / NUMBER_OF_COLUMNS.to_f).ceil
    rows = []
    (0..number_of_rows - 1).each do |n|
      row = []
      (0..contents.length - 1).each do |i|
        row << contents[i].display_name.ljust(padding) if i % number_of_rows == n
      end
      rows << row.join.strip
    end
    rows
  end

  def self.calculate_max_lengths(contents)
    max_lengths = {}
    max_lengths[:display_name] = contents.inject(0) { |max, content| [max, content.display_name.length].max }
    max_lengths[:nlink] = contents.inject(0) { |max, content| [max, content.nlink.to_s.length].max }
    max_lengths[:owner] = contents.inject(0) { |max, content| [max, content.owner.to_s.length].max }
    max_lengths[:group] = contents.inject(0) { |max, content| [max, content.group.to_s.length].max }
    max_lengths[:size] = contents.inject(0) { |max, content| [max, content.size.to_s.length].max }
    max_lengths
  end

  def self.format_mtime(mtime)
    if mtime.strftime('%Y').to_i == Time.now.year
      mtime.strftime('%m %d %H:%M')
    else
      mtime.strftime('%m %d  %Y')
    end
  end

  def self.file_type_string(ftype)
    FILE_TYPE_STRING[ftype]
  end

  def self.file_permission_strings(permission)
    "#{PERMISSON_STRING[permission[-3]]}#{PERMISSON_STRING[permission[-2]]}#{PERMISSON_STRING[permission[-1]]}"
  end

  private_class_method :generate_detail_list, :generate_simple_list, :calculate_max_lengths, :format_mtime, :file_type_string, :file_permission_strings
end
