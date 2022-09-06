# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def strike?
    @shots.first.score == 10
  end

  def spare?
    score == 10 && shots.length == 2
  end

  def score
    shots.inject(0) { |sum, shot| sum + shot.score }
  end
end
