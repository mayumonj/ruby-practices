# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def strike?
    @shots.first.points == 10
  end

  def spare?
    calculate_points == 10 && shots.length == 2
  end

  def calculate_points
    shots.inject(0) { |sum, shot| sum + shot.points }
  end
end
