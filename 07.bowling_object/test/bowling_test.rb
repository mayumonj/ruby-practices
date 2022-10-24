# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

class GameTest < Minitest::Test
  def test_score_including_strike_and_spare
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').calculate_final_score
  end

  def test_score_without_bonus
    assert_equal 71, Game.new('6,3,9,0,0,3,8,1,6,3,1,2,5,1,8,0,1,6,4,4').calculate_final_score
  end

  def test_two_shots_in_the_last_frame
    assert_equal 120, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,1,2').calculate_final_score
  end

  def test_only_one_shot_after_strike
    assert_equal 142, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,0,X,8').calculate_final_score
  end

  def test_no_shot_after_strike
    assert_equal 144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,X').calculate_final_score
  end

  def test_no_shot_after_spare
    assert_equal 153, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,9,1').calculate_final_score
  end

  def test_turkey
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').calculate_final_score
  end

  def test_turkey_in_the_last_frame
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').calculate_final_score
  end

  def test_perfect_score
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').calculate_final_score
  end

  def test_zero_score
    assert_equal 0, Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0').calculate_final_score
  end
end
