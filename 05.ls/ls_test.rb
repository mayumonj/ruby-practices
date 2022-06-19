# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls'

# NOTE: /path/to/ruby-practices/05.ls/test_dir で実行　してください
class LsTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_current_directory
    Dir.chdir('./current_dir')
    assert_equal [
      'file1.txt                   '
    ], get_display_string(nil, nil)
  end

  def test_target_file
    assert_equal './file_a.txt', get_display_string(nil, './file_a.txt')
  end

  def test_target_empty_directory
    assert_nil get_display_string(nil, './empty_dir')
  end

  def test_target_not_exist_directory
    assert_equal 'No such file or directory @ dir_s_chdir - not-exist', get_display_string(nil, 'not-exist').to_s
  end

  def test_show_alias_and_directory
    assert_equal ['alias_a                     child_dir                   file1.txt                   '], get_display_string(nil, './alias_and_dir')
  end

  def test_show_1_content
    assert_equal [
      'file1.txt                   '
    ], get_display_string(nil, './content_1_dir')
  end

  def test_show_2_contents
    assert_equal [
      'file1.txt                   file2.txt                   '
    ], get_display_string(nil, './contents_2_dir')
  end

  def test_show_3_contents
    assert_equal [
      'file1.txt                   file2.txt                   file3.txt                   '
    ], get_display_string(nil, './contents_3_dir')
  end

  def test_show_4_contents
    assert_equal [
      'file1.txt                   file3.txt                   ',
      'file2.txt                   file4.txt                   '
    ], get_display_string(nil, './contents_4_dir')
  end

  def test_show_5_contents
    assert_equal [
      'file1.txt                   file3.txt                   file5.txt                   ',
      'file2.txt                   file4.txt                   '
    ], get_display_string(nil, './contents_5_dir')
  end

  def test_show_6_contents
    assert_equal [
      'file1.txt                   file3.txt                   file5.txt                   ',
      'file2.txt                   file4.txt                   file6.txt                   '
    ], get_display_string(nil, './contents_6_dir')
  end

  def test_show_long_name
    assert_equal [
      'file1.txt                             file4.txt                             looooooooooooooooonoooooog_name.txt   ',
      'file2.txt                             file5.txt                             ',
      'file3.txt                             file6.txt                             '
    ], get_display_string(nil, './having_long_name_file')
  end
end

class LsAoptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_current_directory_option_a
    Dir.chdir('./current_dir')
    assert_equal ['.                           file1.txt                   '], get_display_string('-a', nil)
  end

  def test_target_file_option_a
    assert_equal './file_a.txt', get_display_string('-a', './file_a.txt')
  end

  def test_target_empty_directory_option_a
    assert_equal ['.                           '], get_display_string('-a', './empty_dir')
  end

  def test_target_not_exist_directory_option_a
    assert_equal 'No such file or directory @ dir_s_chdir - not-exist', get_display_string('-a', 'not-exist').to_s
  end

  def test_show_alias_and_directory_option_a
    assert_equal [
      '.                           alias_a                     file1.txt                   ',
      '.DS_Store                   child_dir                   '
    ], get_display_string('-a', './alias_and_dir')
  end
end

class LsRoptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_empty_directory_option_r
    assert_nil get_display_string('-r', './empty_dir')
  end

  def test_show_contents_option_r
    assert_equal [
      'file1.txt                   child_dir                   alias_a                     '
    ], get_display_string('-r', './alias_and_dir')
  end
end

class LsMultiOptionsTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_show_contents_option_ar
    assert_equal [
      'file1.txt                   alias_a                     .                           ',
      'child_dir                   .DS_Store                   '
    ], get_display_string('-ar', './alias_and_dir')
  end

  def test_show_contents_option_ra
    assert_equal [
      'file1.txt                   alias_a                     .                           ',
      'child_dir                   .DS_Store                   '
    ], get_display_string('-ra', './alias_and_dir')
  end
end

class LsInvalidOptionsTest < Minitest::Test
  def test_invalid_option
    assert_equal [nil, nil, 'invalid option'], options_and_path(['-j', './alias_and_dir'])
  end

  def test_invalid_option_with_other_options
    assert_equal [nil, nil, 'invalid option'], options_and_path(['-jar', './alias_and_dir'])
  end
end
