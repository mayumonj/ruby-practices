require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

opt.on('-m VAL') { |v| params[:m] = v }
opt.on('-y VAL') { |v| params[:y] = v }

opt.parse!(ARGV)

if !params[:y].nil? && (params[:y].to_i < 1 || params[:y].to_i > 9999)
  puts "year `#{params[:y]}' not in range 1..9999"
  return
end

if !params[:m].nil? && (params[:m].to_i < 1 || params[:m].to_i > 12)
  puts "#{params[:m]} is neither a month number (1..12) nor a name"
  return
end

year = params[:y].nil? ? Date.today.year : params[:y].to_i
month = params[:m].nil? ? Date.today.month : params[:m].to_i

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

puts "      #{month}月 #{year}"
puts '日 月 火 水 木 金 土'

date = start_date

print ('   ' * date.wday).to_s
while date <= end_date
  print date.day.to_s.rjust(2).to_s
  print date.saturday? ? "\n" : ' '
  date = date.next_day
end
