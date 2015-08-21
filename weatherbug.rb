#!/usr/bin/env ruby
require 'net/telnet'

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
puts response
output = /.This (.*)\n .Tonight/.match(resopnse)
puts output[0]
puts output[1]

#response.each_line do |line|
weatherbug.puts("X")
