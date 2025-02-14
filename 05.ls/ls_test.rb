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
    assert_equal ['.                           file1.txt                   '], get_display_string({ a: true }, nil)
  end

  def test_target_file_option_a
    assert_equal './file_a.txt', get_display_string({ a: true }, './file_a.txt')
  end

  def test_target_empty_directory_option_a
    assert_equal ['.                           '], get_display_string({ a: true }, './empty_dir')
  end

  def test_target_not_exist_directory_option_a
    assert_equal 'No such file or directory @ dir_s_chdir - not-exist', get_display_string({ a: true }, 'not-exist').to_s
  end

  def test_show_alias_and_directory_option_a
    assert_equal [
      '.                           alias_a                     file1.txt                   ',
      '.DS_Store                   child_dir                   '
    ], get_display_string({ a: true }, './alias_and_dir')
  end
end

class LsRoptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_empty_directory_option_r
    assert_nil get_display_string({ r: true }, './empty_dir')
  end

  def test_show_contents_option_r
    assert_equal [
      'file1.txt                   child_dir                   alias_a                     '
    ], get_display_string({ r: true }, './alias_and_dir')
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
    ], get_display_string({ r: true, a: true }, './alias_and_dir')
  end

  def test_show_contents_option_al
    assert_equal [
      'total 32',
      'drwxr-xr-x  6  UserName  staff    192  06 07 22:26  .',
      '-rw-r--r--  1  UserName  staff  10244  06 07 22:33  .DS_Store',
      '-rw-r--r--  1  UserName  staff    936  06 07 22:26  alias_a',
      'drwxr-xr-x  3  UserName  staff     96  06 07 22:26  child_dir',
      '-rw-r--r--  1  UserName  staff      0  06 07 22:26  file1.txt'
    ], get_display_string({ l: true, a: true }, './alias_and_dir')
  end

  def test_show_contents_option_lr
    assert_equal [
      'total 8',
      '-rw-r--r--  1  UserName  staff    0  06 07 22:26  file1.txt',
      'drwxr-xr-x  3  UserName  staff   96  06 07 22:26  child_dir',
      '-rw-r--r--  1  UserName  staff  936  06 07 22:26  alias_a'
    ], get_display_string({ r: true, l: true }, './alias_and_dir')
  end

  def test_show_contents_option_arl
    assert_equal [
      'total 32',
      '-rw-r--r--  1  UserName  staff      0  06 07 22:26  file1.txt',
      'drwxr-xr-x  3  UserName  staff     96  06 07 22:26  child_dir',
      '-rw-r--r--  1  UserName  staff    936  06 07 22:26  alias_a',
      '-rw-r--r--  1  UserName  staff  10244  06 07 22:33  .DS_Store',
      'drwxr-xr-x  6  UserName  staff    192  06 07 22:26  .'
    ], get_display_string({ r: true, a: true, l: true }, './alias_and_dir')
  end
end

class LsInvalidOptionsTest < Minitest::Test
  def test_invalid_option
    assert_equal 'invalid option: -j', options_and_path(['-j'])[2].to_s
  end

  def test_invalid_option_with_other_options
    assert_equal 'invalid option: -ja', options_and_path(['-ja'])[2].to_s
  end

  def test_invalid_option_with_other_options2
    assert_equal 'invalid option: -j', options_and_path(['-aj'])[2].to_s
  end
end

class LsGetOptionsAndPathTest < Minitest::Test
  def test_single_option
    assert_equal [{ r: true }, nil, nil], options_and_path(['-r'])
  end

  def test_multiple_options
    assert_equal [{ r: true, a: true }, nil, nil], options_and_path(['-ra'])
  end

  def test_multiple_options_and_path
    assert_equal [{ r: true, a: true }, '.', nil], options_and_path(['-ar', '.'])
  end
end

class LsLOptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_empty_directory_option_l
    assert_nil get_display_string({ l: true }, './empty_dir')
  end

  def test_show_contents_option_l
    assert_equal [
      'total 8',
      '-rw-r--r--  1  UserName  staff  936  06 07 22:26  alias_a',
      'drwxr-xr-x  3  UserName  staff   96  06 07 22:26  child_dir',
      '-rw-r--r--  1  UserName  staff    0  06 07 22:26  file1.txt'
    ], get_display_string({ l: true }, './alias_and_dir')
  end
end
