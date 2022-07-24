# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'wc'

class WcArgumentTest < Minitest::Test
  CURRENT_DIRECTORY = Dir.pwd

  def setup
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_file
    assert_equal ['       1        2       14 file1.txt'],
                 get_display_string({}, ['file1.txt'])
  end

  def test_two_files
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  '       3        6       39 total'],
                 get_display_string({}, ['file1.txt', 'file2.txt'])
  end

  def test_three_files
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  '       3        6       39 file3.txt',
                  '       6       12       78 total'],
                 get_display_string({}, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_file_path
    Dir.chdir('..')
    assert_equal ['       1        2       14 test_dir/file1.txt',
                  '       2        4       25 test_dir/file2.txt',
                  '       3        6       39 test_dir/file3.txt',
                  '       6       12       78 total'],
                 get_display_string({}, ['test_dir/file1.txt', 'test_dir/file2.txt', 'test_dir/file3.txt'])
  end

  def test_not_exist_file
    assert_equal ['No such file or directory @ rb_sysopen - file99.txt'],
                 get_display_string({}, ['file99.txt'])
  end

  def test_exist_file_and_not_exist_file
    assert_equal ['       1        2       14 file1.txt',
                  'No such file or directory @ rb_sysopen - not-exist.txt',
                  '       1        2       14 total'],
                 get_display_string({}, ['file1.txt', 'not-exist.txt'])
  end

  def test_two_exist_files_and_not_exist_file
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  'No such file or directory @ rb_sysopen - not-exist.txt',
                  '       3        6       39 total'],
                 get_display_string({}, ['file1.txt', 'file2.txt', 'not-exist.txt'])
  end

  def test_directory
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  'Is a directory @ io_fread - child_dir',
                  '       3        6       39 total'],
                 get_display_string({}, ['file1.txt', 'file2.txt', 'child_dir'])
  end

  def test_no_argument
    # 想定結果：入力待ちのまま終わらない
    # のテストをしたい
  end
end

class WcStdinTest < Minitest::Test
  def test_stdin
    # ls -l | ruby ../wc.rb
    # のテストをしたい
    # 想定結果 ['       5       38      245']
  end

  def test_stdin_and_arguments
    # ls -l | ruby ../wc.rb file1.txt
    # のテストをしたい
    # 想定結果 ['       1        2       14 file1.txt']
  end
end

class WcOptionTest < Minitest::Test
  def test_option_l
    assert_equal ['       1 file1.txt',
                  '       2 file2.txt',
                  '       3 file3.txt',
                  '       6 total'],
                 get_display_string({ l: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_w
    assert_equal ['       2 file1.txt',
                  '       4 file2.txt',
                  '       6 file3.txt',
                  '      12 total'],
                 get_display_string({ w: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_c
    assert_equal ['      14 file1.txt',
                  '      25 file2.txt',
                  '      39 file3.txt',
                  '      78 total'],
                 get_display_string({ c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_lw
    assert_equal ['       1        2 file1.txt',
                  '       2        4 file2.txt',
                  '       3        6 file3.txt',
                  '       6       12 total'],
                 get_display_string({ l: true, w: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_lc
    assert_equal ['       1       14 file1.txt',
                  '       2       25 file2.txt',
                  '       3       39 file3.txt',
                  '       6       78 total'],
                 get_display_string({ l: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_wc
    assert_equal ['       2       14 file1.txt',
                  '       4       25 file2.txt',
                  '       6       39 file3.txt',
                  '      12       78 total'],
                 get_display_string({ w: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_lwc
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  '       3        6       39 file3.txt',
                  '       6       12       78 total'],
                 get_display_string({ l: true, w: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_option_cwl
    assert_equal ['       1        2       14 file1.txt',
                  '       2        4       25 file2.txt',
                  '       3        6       39 file3.txt',
                  '       6       12       78 total'],
                 get_display_string({ c: true, w: true, l: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
  end

  def test_single_option_with_error
    assert_equal ['      14 file1.txt',
                  '      25 file2.txt',
                  'No such file or directory @ rb_sysopen - not-exist.txt',
                  '      39 total'],
                 get_display_string({ c: true }, ['file1.txt', 'file2.txt', 'not-exist.txt'])
  end

  def test_two_options_with_error
    assert_equal ['       1        2 file1.txt',
                  '       2        4 file2.txt',
                  'No such file or directory @ rb_sysopen - not-exist.txt',
                  '       3        6 total'],
                 get_display_string({ l: true, w: true }, ['file1.txt', 'file2.txt', 'not-exist.txt'])
  end
end
