# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'
require_relative '../lib/content_factory'
require_relative '../lib/content'
require_relative '../lib/argument_parser'

# /path/to/ruby-practices/08.ls_object/test_dir で実行してください
# UserName, ファイル作成日付は書き換える必要があります

class LsTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_current_directory
    Dir.chdir('./current_dir')
    contents = ContentFactory.create_contents(nil)
    assert_equal [
      'file1.txt'
    ], Ls.display({}, contents)
  end

  def test_target_file
    contents = ContentFactory.create_contents('./file_a.txt')
    assert_equal [
      './file_a.txt'
    ], Ls.display({}, contents)
  end

  def test_target_empty_directory
    contents = ContentFactory.create_contents('./empty_dir')
    assert_nil Ls.display({}, contents)
  end

  def test_target_not_exist_directory
    ContentFactory.create_contents('not-exist')
  rescue ArgumentError => e
    assert_equal 'ls: not-exist: No such file or directory', e.message
  end

  def test_show_alias_and_directory
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal ['alias_a    child_dir  file1.txt'], Ls.display({}, contents)
  end

  def test_show_1_content
    contents = ContentFactory.create_contents('./content_1_dir')
    assert_equal [
      'file1.txt'
    ], Ls.display({}, contents)
  end

  def test_show_2_contents
    contents = ContentFactory.create_contents('./contents_2_dir')
    assert_equal [
      'file1.txt  file2.txt'
    ], Ls.display({}, contents)
  end

  def test_show_3_contents
    contents = ContentFactory.create_contents('./contents_3_dir')
    assert_equal [
      'file1.txt  file2.txt  file3.txt'
    ], Ls.display({}, contents)
  end

  def test_show_4_contents
    contents = ContentFactory.create_contents('./contents_4_dir')
    assert_equal [
      'file1.txt  file3.txt',
      'file2.txt  file4.txt'
    ], Ls.display({}, contents)
  end

  def test_show_5_contents
    contents = ContentFactory.create_contents('./contents_5_dir')
    assert_equal [
      'file1.txt  file3.txt  file5.txt',
      'file2.txt  file4.txt'
    ], Ls.display({}, contents)
  end

  def test_show_6_contents
    contents = ContentFactory.create_contents('./contents_6_dir')
    assert_equal [
      'file1.txt  file3.txt  file5.txt',
      'file2.txt  file4.txt  file6.txt'
    ], Ls.display({}, contents)
  end

  def test_show_long_name
    contents = ContentFactory.create_contents('./having_long_name_file')
    assert_equal [
      'file1.txt                            file4.txt                            looooooooooooooooonoooooog_name.txt',
      'file2.txt                            file5.txt',
      'file3.txt                            file6.txt'
    ], Ls.display({}, contents)
  end
end

class LsAoptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_current_directory_option_a
    Dir.chdir('./current_dir')
    contents = ContentFactory.create_contents(nil)
    assert_equal ['.          file1.txt'], Ls.display({ a: true }, contents)
  end

  def test_target_empty_directory_option_a
    contents = ContentFactory.create_contents('./empty_dir')
    assert_equal ['.'], Ls.display({ a: true }, contents)
  end

  def test_show_alias_and_directory_option_a
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      '.          alias_a    file1.txt',
      '.DS_Store  child_dir'
    ], Ls.display({ a: true }, contents)
  end
end

class LsRoptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_empty_directory_option_r
    contents = ContentFactory.create_contents('./empty_dir')
    assert_nil Ls.display({ r: true }, contents)
  end

  def test_show_contents_option_r
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'file1.txt  child_dir  alias_a'
    ], Ls.display({ r: true }, contents)
  end
end

class LsMultiOptionsTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_show_contents_option_ar
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'file1.txt  alias_a    .',
      'child_dir  .DS_Store'
    ], Ls.display({ r: true, a: true }, contents)
  end

  def test_show_contents_option_al
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'total 32',
      'drwxr-xr-x  6  UserName  staff    192  10 22 10:36  .',
      '-rw-r--r--  1  UserName  staff  10244  09 06 20:53  .DS_Store',
      '-rw-r--r--  1  UserName  staff    936  10 22 10:36  alias_a',
      'drwxr-xr-x  3  UserName  staff     96  10 22 10:36  child_dir',
      '-rw-r--r--  1  UserName  staff      0  10 22 10:36  file1.txt'
    ], Ls.display({ a: true, l: true }, contents)
  end

  def test_show_contents_option_lr
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'total 8',
      '-rw-r--r--  1  UserName  staff    0  10 22 10:36  file1.txt',
      'drwxr-xr-x  3  UserName  staff   96  10 22 10:36  child_dir',
      '-rw-r--r--  1  UserName  staff  936  10 22 10:36  alias_a'
    ], Ls.display({ l: true, r: true }, contents)
  end

  def test_show_contents_option_arl
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'total 32',
      '-rw-r--r--  1  UserName  staff      0  10 22 10:36  file1.txt',
      'drwxr-xr-x  3  UserName  staff     96  10 22 10:36  child_dir',
      '-rw-r--r--  1  UserName  staff    936  10 22 10:36  alias_a',
      '-rw-r--r--  1  UserName  staff  10244  09 06 20:53  .DS_Store',
      'drwxr-xr-x  6  UserName  staff    192  10 22 10:36  .'
    ], Ls.display({ a: true, r: true, l: true }, contents)
  end
end

class LsInvalidOptionsTest < Minitest::Test
  def test_invalid_option
    argument_parser = ArgumentParser.new(['-j'])
    assert_equal 'invalid option: -j', argument_parser.error_message
  end

  def test_invalid_option_with_other_options
    argument_parser = ArgumentParser.new(['-ja'])
    assert_equal 'invalid option: -ja', argument_parser.error_message
  end

  def test_invalid_option_with_other_options2
    argument_parser = ArgumentParser.new(['-aj'])
    assert_equal 'invalid option: -j', argument_parser.error_message
  end
end

class LsLOptionTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_target_empty_directory_option_l
    contents = ContentFactory.create_contents('./empty_dir')
    assert_nil Ls.display({ l: true }, contents)
  end

  def test_show_contents_option_l
    contents = ContentFactory.create_contents('./alias_and_dir')
    assert_equal [
      'total 8',
      '-rw-r--r--  1  UserName  staff  936  10 22 10:36  alias_a',
      'drwxr-xr-x  3  UserName  staff   96  10 22 10:36  child_dir',
      '-rw-r--r--  1  UserName  staff    0  10 22 10:36  file1.txt'
    ], Ls.display({ l: true }, contents)
  end
end
