#!/usr/bin/env ruby
require 'net/telnet'
require 'pp'
form="short"

def merge_response(buffer)
  output=[] 
  start=finish=0
  buffer.size.times do |i|
    if i < 8 then 
      next
    end
    #Stripping newlines
    buffer[i].strip!
    #Checking for the first '.'
    if buffer[i][0] == '.' then 
      start=i;
    end
    #Checking for the last '.'
    if buffer[i][-1] == '.' then
      finish += 1
      #Saving in output
      output.push(buffer[start,(finish-start)+1]) #The line is complete
      next
    else #Line continues to next 
      #puts "set finish to: #{i}"
      finish = i
      next
    end
     #Line is a continuation of the previous line
  end
  output.map! do |arr|
    arr.join
  end
  return output
end

#returning the proper Unicode character for the weather
def parse_weather(line)
  if line =~ /\.\.\..*[sS]unny/ then
    return "\u2600"
  elsif line =~ /\.\.\..*[cC]loudy/ then
    return "\u2601"
  elsif line =~ /\.\.\..*[rR]ain/ then
    return "\u2602"
  elsif line =~ /\.\.\..*[cC]lear/ then
    return "\u263d"
  end
end

##################################################
# Main Function
##################################################
if (ARGV.size < 1) then
  puts "Usage: weatherbug airport-code"
  exit
end

if ARGV.include? "-l"
  form="long"
elsif ARGV.include? "-s" 
  form="short"
end

weatherbug = Net::Telnet::new( "Host" => "rainmaker.wunderground.com" )
weatherbug.waitfor(/continue:/)
weatherbug.puts("")
weatherbug.waitfor(/code--/)
weatherbug.puts(ARGV.first.to_s)
response = weatherbug.waitfor(/X to exit:/)
weatherbug.puts("X")
if form == "long" then
  puts response
elsif form == "short"  then 
  output = merge_response(response.lines)
  output.each do |line|
    md = /\.(.*?)\.\.\./.match(line)
    char = parse_weather(line)
    puts "#{md[1]}: #{char}".encode
  end
end
