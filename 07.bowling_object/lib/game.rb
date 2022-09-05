# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(marks_str)
    @shots = marks_str.split(',').map { |mark| Shot.new(mark) }
  end

  def point_result
    sum = 0
    (0..9).each do |n|
      frame, next_frame, after_next_frame = frames.slice(n, 3)
      next_frame ||= Frame.new(nil)
      after_next_frame ||= Frame.new(nil)
      left_shots = next_frame.shots + after_next_frame.shots

      sum += frame.score
      sum += bonus_point(left_shots.slice(0, 2)) if frame.strike?
      sum += bonus_point(left_shots.slice(0, 1)) if frame.spare?
    end
    sum
  end

  private

  def frames
    frames = []
    frame = Frame.new(nil)
    @shots.each do |shot|
      frame.shots << shot
      if frames.size < 10
        if frame.shots.size >= 2 || shot.score == 10
          frames << frame
          frame = Frame.new(nil)
        end
      else
        frames.last.shots << shot
      end
    end
    frames
  end

  def bonus_point(shots)
    shots.inject(0) { |sum, shot| sum + shot.score }
  end
end
