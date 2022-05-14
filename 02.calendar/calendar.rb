require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

opt.on('-m VAL') {|v| params[:m] = v}
opt.on('-y VAL') {|v| params[:y] = v}

opt.parse!(ARGV)

if params[:y] != nil and (params[:y].to_i < 1 or params[:y].to_i > 9999)
  puts "year `#{params[:y]}' not in range 1..9999"
  return
end

if params[:m] != nil and (params[:m].to_i < 1 or params[:m].to_i > 12)
  puts "#{params[:m]} is neither a month number (1..12) nor a name"
  return
end

params[:y].nil? ? year = Date.today.year : year = params[:y].to_i
params[:m].nil? ? month = Date.today.month : month = params[:m].to_i

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
