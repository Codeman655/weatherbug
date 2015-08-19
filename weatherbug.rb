#!/usr/bin/env ruby
require 'net/telnet'

weatherbug = Net::Telnet::new( "Host" => "rainmaker.wunderground.com" )
weatherbug.waitfor(/continue:/)
weatherbug.puts("")
#puts response
weatherbug.waitfor(/code--/)
weatherbug.puts("TYS")
#puts response
#response = weatherbug.waitfor(/X to exit:/){|c| puts c}
weatherbug.waitfor(/X to exit:/){|c| puts c}
#puts response
#response.each_line do |line|
weatherbug.puts("X")
