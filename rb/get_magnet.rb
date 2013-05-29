#!/usr/bin/ruby

magnet = ARGV[0]
category = ARGV[1]

if( magnet.nil? || magnet.length == 0 )
  puts "Usage: {ruby|./}script magnet_file {category}"
  exit
end

url = "d10:magnet-uri#{magnet.length}:#{magnet}e"

if !category.nil? && category.length > 0
  filename = magnet.split(":")[3].split("&").first
  file = "/mnt/data/Public/Torrents/#{category}/magnet_#{filename}.torrent"
  
  File.open(file, "w+").write(url)
  puts filename
  puts file
  puts url
else
  puts url
end


