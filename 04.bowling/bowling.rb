# frozen_string_literal: true

# 引数をとる
score = ARGV[0]

# 1投ごとに分割する
scores = score.split(',')

# 数字に変換
shots = []
scores.each do |s|
  if s == 'X' # strike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# フレームごとに分割
frames = []
shots.each_slice(2) do |s|
  frames << s
end

if frames.length > 10
  frame10 = []
  frames.drop(9).each do |frame|
    frame.delete(0) if frame == [10, 0]
    frame10 += frame
  end
  frames = frames.take(9).append(frame10)
end

# 得点計算
point = 0
(0..9).each do |i|
  point +=  if i <= 8 && frames[i][0] == 10 # strike
              # ストライクのフレームの得点は次の2投の点を加算する（最終フレームは加算なし）
              if frames[i + 1][0] == 10
                if i == 8
                  10 + frames[i + 1][0] + frames[i + 1][1]
                else
                  10 + frames[i + 1][0] + frames[i + 2][0]
                end
              else
                10 + frames[i + 1][0] + frames[i + 1][1]
              end
            elsif i <= 8 && frames[i].sum == 10 # spare
              # スペアのフレームの得点は次の1投の点を加算する（最終フレームは加算なし）
              10 + frames[i + 1][0]
            else
              frames[i].sum
            end
end
puts point
