# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls'

class GateTest < Minitest::Test
  # NOTE: /path/to/ruby-practices/05.ls/test_dir で実行　してください
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_case1
    Dir.chdir(Dir.pwd)
    assert_equal ['alias_a                     child_dir                   file_a.txt                  '],
                 get_display_string(nil)
  end

  def test_other_directory
    assert_equal ['empty_dir                   file_b.txt                  '], get_display_string('./child_dir')
  end

  def test_empty_directory
    assert_nil get_display_string('./child_dir/empty_dir')
  end

  def test_not_exist_directory
    assert_equal 'No such file or directory @ dir_s_chdir - not-exist', get_display_string('not-exist').to_s
  end

  def test_file
    assert_equal './file_a.txt', get_display_string('./file_a.txt')
  end
end