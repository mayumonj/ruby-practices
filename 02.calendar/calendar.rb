require 'optparse'
require 'date'

def get_year_month(params)
  year = params[:y] ? params[:y].to_i : Date.today.year
  month = params[:m] ? params[:m].to_i : Date.today.month
  [year, month]
end

def valid_year?(year)
  return true if year in (1..9999)

  puts "year `#{year}' not in range 1..9999"
  false
end

def valid_month?(month)
  return true if month in (1..12)

  puts "#{month} is neither a month number (1..12) nor a name"
  false
end

opt = OptionParser.new
params = {}

opt.on('-m VAL') { |v| params[:m] = v }
opt.on('-y VAL') { |v| params[:y] = v }

opt.parse!(ARGV)

year, month = get_year_month(params)
return unless valid_year?(year)
return unless valid_month?(month)

puts "      #{month}月 #{year}"
puts '日 月 火 水 木 金 土'

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

print '   ' * start_date.wday
(start_date..end_date).each do |date|
  print date.day.to_s.rjust(2)
  print date.saturday? ? "\n" : ' '
end
