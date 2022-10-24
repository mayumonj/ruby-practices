# frozen_string_literal: true

class Shot
  attr_reader :points

  def initialize(mark)
    @points = to_points(mark)
  end

  private

  def to_points(mark)
    mark == 'X' ? 10 : mark.to_i
  end
end
