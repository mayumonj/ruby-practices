# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'wc'

class WcArgumentTest < Minitest::Test
  def test_file
    assert_equal ['       1        2       14 file1.txt'],
                 build_display_text({}, ['file1.txt'])
  end

  def test_two_files
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      \       3        6       39 total
    TEXT
    actual = build_display_text({}, ['file1.txt', 'file2.txt'])
    assert_equal expected, actual
  end

  def test_three_files
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      \       3        6       39 file3.txt
      \       6       12       78 total
    TEXT
    actual = build_display_text({}, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_file_path
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       18 child_dir/child_file1.txt
      \       2        4       37 child_dir/child_file2.txt
      \       3        6       57 child_dir/child_file3.txt
      \       6       12      112 total
    TEXT
    actual = build_display_text({}, ['child_dir/child_file1.txt', 'child_dir/child_file2.txt', 'child_dir/child_file3.txt'])
    assert_equal expected, actual
  end

  def test_not_exist_file
    assert_equal ['No such file or directory @ rb_sysopen - file99.txt'],
                 build_display_text({}, ['file99.txt'])
  end

  def test_exist_file_and_not_exist_file
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      No such file or directory @ rb_sysopen - not-exist.txt
      \       1        2       14 total
    TEXT
    actual = build_display_text({}, ['file1.txt', 'not-exist.txt'])
    assert_equal expected, actual
  end

  def test_two_exist_files_and_not_exist_file
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      No such file or directory @ rb_sysopen - not-exist.txt
      \       3        6       39 total
    TEXT
    actual = build_display_text({}, ['file1.txt', 'file2.txt', 'not-exist.txt'])
    assert_equal expected, actual
  end

  def test_directory
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      Is a directory @ io_fread - child_dir
      \       3        6       39 total
    TEXT
    actual = build_display_text({}, ['file1.txt', 'file2.txt', 'child_dir'])
    assert_equal expected, actual
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
    expected = <<~TEXT.lines(chomp: true)
      \       1 file1.txt
      \       2 file2.txt
      \       3 file3.txt
      \       6 total
    TEXT
    actual = build_display_text({ l: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_w
    expected = <<~TEXT.lines(chomp: true)
      \       2 file1.txt
      \       4 file2.txt
      \       6 file3.txt
      \      12 total
    TEXT
    actual = build_display_text({ w: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_c
    expected = <<~TEXT.lines(chomp: true)
      \      14 file1.txt
      \      25 file2.txt
      \      39 file3.txt
      \      78 total
    TEXT
    actual = build_display_text({ c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_lw
    expected = <<~TEXT.lines(chomp: true)
      \       1        2 file1.txt
      \       2        4 file2.txt
      \       3        6 file3.txt
      \       6       12 total
    TEXT
    actual = build_display_text({ l: true, w: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_lc
    expected = <<~TEXT.lines(chomp: true)
      \       1       14 file1.txt
      \       2       25 file2.txt
      \       3       39 file3.txt
      \       6       78 total
    TEXT
    actual = build_display_text({ l: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_wc
    expected = <<~TEXT.lines(chomp: true)
      \       2       14 file1.txt
      \       4       25 file2.txt
      \       6       39 file3.txt
      \      12       78 total
    TEXT
    actual = build_display_text({ w: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_lwc
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      \       3        6       39 file3.txt
      \       6       12       78 total
    TEXT
    actual = build_display_text({ l: true, w: true, c: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_option_cwl
    expected = <<~TEXT.lines(chomp: true)
      \       1        2       14 file1.txt
      \       2        4       25 file2.txt
      \       3        6       39 file3.txt
      \       6       12       78 total
    TEXT
    actual = build_display_text({ c: true, w: true, l: true }, ['file1.txt', 'file2.txt', 'file3.txt'])
    assert_equal expected, actual
  end

  def test_single_option_with_error
    expected = <<~TEXT.lines(chomp: true)
      \      14 file1.txt
      \      25 file2.txt
      No such file or directory @ rb_sysopen - not-exist.txt
      \      39 total
    TEXT
    actual = build_display_text({ c: true }, ['file1.txt', 'file2.txt', 'not-exist.txt'])
    assert_equal expected, actual
  end

  def test_two_options_with_error
    expected = <<~TEXT.lines(chomp: true)
      \       1        2 file1.txt
      \       2        4 file2.txt
      No such file or directory @ rb_sysopen - not-exist.txt
      \       3        6 total
    TEXT
    actual = build_display_text({ l: true, w: true }, ['file1.txt', 'file2.txt', 'not-exist.txt'])
    assert_equal expected, actual
  end
end
