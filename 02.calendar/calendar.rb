require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

opt.on('-m VAL') {|v| params[:m] = v.to_i}
opt.on('-y VAL') {|v| params[:y] = v.to_i}

opt.parse!(ARGV)

params[:y].nil? ? year = Date.today.year : year = params[:y]
params[:m].nil? ? month = Date.today.month : month = params[:m]

start_date = Date.new(year,month,1)
end_date = start_date.next_month.prev_day

# 年月の行を出力する
print "      #{month}月 #{year}\n"

# 曜日の行を出力する
print "日 月 火 水 木 金 土\n"

# 1日目を出力する（2文字右寄せ）
date = start_date
print "#{"   "*date.wday}#{date.day.to_s.rjust(2)}"
if date.saturday?
  print "\n"
else
  print " "
end
date = date.next_day

# 2日目以降を出力する、end_dateまできたら終了
while date <= end_date
  print "#{date.day.to_s.rjust(2)}"
  if date.saturday?
    print "\n"
  else
    print " "
  end
  date = date.next_day
end