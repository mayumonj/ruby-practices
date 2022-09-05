# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots || []
  end

  def strike?
    @shots.first.score == 10
  end

  def spare?
    score == 10 && shots.length == 2
  end

  def score
    sum = 0
    shots.each do |shot|
      sum += shot.score
    end
    sum
  end
end
