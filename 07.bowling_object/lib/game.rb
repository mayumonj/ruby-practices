# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(marks_str)
    @shots = marks_str.split(',').map { |mark| Shot.new(mark) }
    @frames = create_frames
  end

  def calculate_final_score
    sum = 0
    (0..9).each do |n|
      frame, next_frame, after_next_frame = @frames.slice(n, 3)
      next_frame ||= Frame.new
      after_next_frame ||= Frame.new
      left_shots = next_frame.shots + after_next_frame.shots

      sum += frame.calculate_points
      sum += calculate_bonus_points(left_shots.slice(0, 2)) if frame.strike?
      sum += calculate_bonus_points(left_shots.slice(0, 1)) if frame.spare?
    end
    sum
  end

  private

  def create_frames
    frames = []
    frame = Frame.new
    @shots.each do |shot|
      frame.shots << shot
      if frames.size < 10
        if frame.shots.size >= 2 || shot.points == 10
          frames << frame
          frame = Frame.new
        end
      else
        frames.last.shots << shot
      end
    end
    frames
  end

  def calculate_bonus_points(shots)
    shots.inject(0) { |sum, shot| sum + shot.points }
  end
end
