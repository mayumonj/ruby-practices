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
end_date = Date.new(year,month,-1)

print "      #{month}月 #{year}\n"
print "日 月 火 水 木 金 土\n"

date = start_date

print "#{"   "*date.wday}#{date.day.to_s.rjust(2)}"
print date.saturday? ?  "\n" : " "
date = date.next_day

while date <= end_date
  print "#{date.day.to_s.rjust(2)}"
  print date.saturday? ?  "\n" : " "
  date = date.next_day
end