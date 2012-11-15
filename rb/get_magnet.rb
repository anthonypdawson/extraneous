#!/usr/bin/ruby

magnet = ARGV[0]
torrent_dir = "~/Public/Torrents"
category = nil
ARGV.each do |arg|
#  puts arg
  category = arg.split("=").last if arg.start_with?("c=")
  torrent_dir = arg.split("=").last if arg.start_with?("dir=")
end

if( magnet.nil? || magnet.length == 0 )
  puts "Usage: {ruby|./}script magnet_file {category} {dir=torrent_dir}"
  exit
end

url = "d10:magnet-uri#{magnet.length}:#{magnet}e"

if !category.nil? && category.length > 0
  puts "Using directory : #{torrent_dir}\n Using category : #{category}\n\n"
  filename = magnet.split(":")[3].split("&").first
  file = "#{torrent_dir}/#{category}/magnet_#{filename}.torrent"
  File.open(file, "w+").write(url)
  puts filename
  puts file
  puts url
else
  puts url
end


