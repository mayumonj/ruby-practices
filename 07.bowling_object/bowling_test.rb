# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'game'
require_relative 'frame'
require_relative 'shot'

class GameTest < Minitest::Test
  def test_point_result
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').point_result
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').point_result
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').point_result
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').point_result
    assert_equal 144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').point_result
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').point_result
    assert_equal 0, Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0').point_result
  end
end
