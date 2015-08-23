#!/usr/bin/env ruby
require 'net/telnet'
require 'pp'
form="short"

def merge_response(buffer)
  output=[] 
  start=finish=0
  #puts "total buffer lines: " + buffer.size.to_s
  buffer.size.times do |i|
    if i < 8 then 
      next
    end
    buffer[i].strip!
    #puts i
    #puts "line content is:"
    #pp buffer[i].strip!
    #puts "checking first period"
    #puts buffer[i][0]
    if buffer[i][0] == '.' then #TODO regex here =~ /^\./
      #puts "set start = " + i.to_s
      start=i;
    end
    #puts "checking last period"
    #puts buffer[i][-1]
    if buffer[i][-1] == '.' then
      finish += 1
      #Saving in output
      #puts "start: " + start.to_s
      #puts "end: " + finish.to_s
      #puts "exporting the string:"
      #puts buffer[start,(finish-start)+1]
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

##################################################
# Main Function
##################################################
if (ARGV.size < 1) then
  puts "Usage: weatherbug airport-code"
  exit
end

if ARGV.include? "-l"
  FORM="long"
elsif ARGV.include? "-s" 
  FORM="short"
end

weatherbug = Net::Telnet::new( "Host" => "rainmaker.wunderground.com" )
weatherbug.waitfor(/continue:/)
weatherbug.puts("")
#puts response
weatherbug.waitfor(/code--/)
weatherbug.puts(ARGV.first.to_s)
#puts response
response = weatherbug.waitfor(/X to exit:/)
weatherbug.puts("X")
#weatherbug.waitfor(/X to exit:/){|c| puts c}
#puts response
#print response.lines
if form == "long" then
  puts response
elsif form == "short"  then 
  output = merge_response(response.lines)
  output.each do |line|
    md = /\.(\w+)/.match(line)
    puts "#{md[1]}: \u2600".encode
  end
end
#response.each_line do |line|
