def main
  point = get_point(ARGV[0])
  puts point
end

def get_point(score_str)
  shots = get_shots(score_str)
  frames = get_frames(shots)
  calc_total_point(frames)
end

def get_shots(score_str)
  scores = score_str.split(',')
  scores.flat_map do |s|
    s == 'X' ? [10, 0] : s.to_i
  end
end

def get_frames(shots)
  frames = shots.each_slice(2).to_a

  if frames.length > 10
    final_frame = frames[9..].flat_map do |frame|
      frame[0] == 10 ? 10 : frame
    end
    frames = [*frames[..8], final_frame]
  end
  frames
end

def calc_total_point(frames)
  point = (0..8).sum do |i|
    current_frame = frames[i]
    next_frame = frames[i + 1]
    after_next_frame = frames[i + 2]
    is_one_before_final_frame = (i == 8)

    if spare?(current_frame)
      10 + next_frame[0]
    elsif strike?(current_frame) && !strike?(next_frame)
      10 + next_frame[0] + next_frame[1]
    elsif strike?(current_frame) && strike?(next_frame)
      if is_one_before_final_frame
        10 + next_frame[0] + next_frame[1]
      else
        10 + next_frame[0] + after_next_frame[0]
      end
    else
      current_frame.sum
    end
  end

  point + frames[9].sum
end

def open_frame?(frame)
  !(strike?(frame) || spare?(frame))
end

def strike?(frame)
  frame[0] == 10
end

def spare?(frame)
  !strike?(frame) && frame.sum == 10
end

main if __FILE__ == $PROGRAM_NAME
