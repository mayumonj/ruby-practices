require 'optparse'
require 'date'

def get_default_year_and_month(params)
  year = params[:y].nil? ? Date.today.year : params[:y].to_i
  month = params[:m].nil? ? Date.today.month : params[:m].to_i
  [year, month]
end

def validate_year(year)
  return unless year < 1 || year > 9999

  puts "year `#{year}' not in range 1..9999"
  exit
end

def validate_month(month)
  return unless month < 1 || month > 12

  puts "#{month} is neither a month number (1..12) nor a name"
  exit
end

opt = OptionParser.new
params = {}

opt.on('-m VAL') { |v| params[:m] = v }
opt.on('-y VAL') { |v| params[:y] = v }

opt.parse!(ARGV)

year, month = get_default_year_and_month(params)
validate_year(year)
validate_month(month)

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
