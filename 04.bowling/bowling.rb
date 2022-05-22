def strike?(frame)
  frame[0] == 10
end

def spare?(frame)
  !strike?(frame) && frame.sum == 10
end

score_str = ARGV[0]
scores = score_str.split(',')
shots = scores.flat_map do |s|
  s == 'X' ? [10, 0] : s.to_i
end

frames = shots.each_slice(2).to_a

if frames.length > 10
  final_frame = frames[9..].flat_map do |frame|
    frame[0] == 10 ? 10 : frame
  end
  frames = [*frames[..8], final_frame]
end

point = 0
(0..8).each do |i|
  current_frame = frames[i]
  next_frame = frames[i + 1]
  after_next_frame = frames[i + 2]
  def open_frame?(frame) = !(strike?(frame) || spare?(frame))
  def one_before_final_frame?(frame_index) = (frame_index == 8)

  point += if open_frame?(current_frame)
             current_frame.sum
           elsif spare?(current_frame)
             10 + next_frame[0]
           elsif strike?(current_frame) && !strike?(next_frame)
             10 + next_frame[0] + next_frame[1]
           elsif strike?(current_frame) && strike?(next_frame)
             if one_before_final_frame?(i)
               10 + next_frame[0] + next_frame[1]
             else
               10 + next_frame[0] + after_next_frame[0]
             end
           end
end

puts point + frames[9].sum
