# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls'

class GateTest < Minitest::Test
  # NOTE: /path/to/ruby-practices/05.ls/test_dir で実行　してください
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_current_directory
    Dir.chdir('./current_dir')
    assert_equal [
      'file1.txt                   '
    ], get_display_string(nil)
  end

  def test_target_file
    assert_equal './file_a.txt', get_display_string('./file_a.txt')
  end

  def test_target_empty_directory
    assert_nil get_display_string('./empty_dir')
  end

  def test_target_not_exist_directory
    assert_equal 'No such file or directory @ dir_s_chdir - not-exist', get_display_string('not-exist').to_s
  end

  def test_show_alias_and_directory
    assert_equal ['alias_a                     child_dir                   file1.txt                   '], get_display_string('./alias_and_dir')
  end

  def test_show_1_content
    assert_equal [
      'file1.txt                   '
    ], get_display_string('./content_1_dir')
  end

  def test_show_2_contents
    assert_equal [
      'file1.txt                   file2.txt                   '
    ], get_display_string('./contents_2_dir')
  end

  def test_show_3_contents
    assert_equal [
      'file1.txt                   file2.txt                   file3.txt                   '
    ], get_display_string('./contents_3_dir')
  end

  def test_show_4_contents
    assert_equal [
      'file1.txt                   file3.txt                   ',
      'file2.txt                   file4.txt                   '
    ], get_display_string('./contents_4_dir')
  end

  def test_show_5_contents
    assert_equal [
      'file1.txt                   file3.txt                   file5.txt                   ',
      'file2.txt                   file4.txt                   '
    ], get_display_string('./contents_5_dir')
  end

  def test_show_6_contents
    assert_equal [
      'file1.txt                   file3.txt                   file5.txt                   ',
      'file2.txt                   file4.txt                   file6.txt                   '
    ], get_display_string('./contents_6_dir')
  end

  def test_show_long_name
    assert_equal [
      'file1.txt                             file4.txt                             looooooooooooooooonoooooog_name.txt   ',
      'file2.txt                             file5.txt                             ',
      'file3.txt                             file6.txt                             '
    ], get_display_string('./having_long_name_file')
  end
end
