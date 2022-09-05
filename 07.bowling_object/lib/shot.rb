# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(mark)
    @score = to_score(mark)
  end

  private

  def to_score(mark)
    mark == 'X' ? 10 : mark.to_i
  end
end
