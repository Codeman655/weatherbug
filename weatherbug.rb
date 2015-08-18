#!/usr/bin/env ruby
require 'net/telnet'

weatherbug = Net::Telnet::new( "Host" => "rainmaker.wunderground.com"
  #"Port" => 23
  #"Prompt" => "/.*[:-]$/"
  #"Telnetmode" => false
)
weatherbug.waitfor(/continue:/){|c| print c}
response = weatherbug.puts("")
puts response
weatherbug.waitfor(/code--/)
response = weatherbug.puts("TYS"){|c| print c}
puts response
weatherbug.waitfor(/X to exit:/){|c| print c}
response = weatherbug.puts("X")
