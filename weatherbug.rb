#!/usr/bin/env ruby
require 'net/telnet'

def merge_response(buffer)
  output=[] 
  start=finish=0
  puts "total buffer lines: " + buffer.size.to_s
  buffer.size.times do |i|
    if i < 8 then 
      next
    end
    puts i
    puts "working on line: " + buffer[i]
    if buffer[i][0] == '.' then
      puts "set start = " + i.to_s
      start=i;
    end
    if buffer[i][-2] == '.' then
      #Saving in output
      puts "start: " + start.to_s
      puts "end: " + finish.to_s
      output.push(buffer[start,(finish-start)+1]) #The line is complete
      next
    else #Line continues to next 
      finish +=1
      next
    end
     #Line is a continuation of the previous line
  end
  print output
  return output
end

if (ARGV.size != 1) then
  puts "Usage: weatherbug airport-code"
  exit
end

weatherbug = Net::Telnet::new( "Host" => "rainmaker.wunderground.com" )
weatherbug.waitfor(/continue:/)
weatherbug.puts("")
#puts response
weatherbug.waitfor(/code--/)
weatherbug.puts(ARGV.first.to_s)
#puts response
response = weatherbug.waitfor(/X to exit:/)
#weatherbug.waitfor(/X to exit:/){|c| puts c}
#puts response
#print response.lines
merge_response(response.lines)
#response.each_line do |line|
weatherbug.puts("X")
