#!/usr/local/bin

require 'open3'
require 'shellwords'
args = ARGV
directory = ARGV.first
readFromFile = false
useTcprobe = false
if(args.length >= 1)
  args.each do |a|
    command = a.split("=").first
    value = a.split("=").last
    if(command == "fromFile")
      readFromFile = value
    end
    if(command == "app")
      useTcprobe = (value == "tcprobe")
    end
    if(command == "directory")
      directory = value
      puts "Using #{value}"
    end
  end
end
videos = []
local_filename = "list_of_bad_files.txt"

files = []

if(readFromFile)
  files = File.open(readFromFile).read
end
if(!readFromFile and !File.directory?(directory))
  puts "Directory doesn't exist!"
end
if(!readFromFile and File.directory?(directory))
    command = "find " +  directory + " -regextype posix-egrep -regex " + "\".*(mkv|avi|m4v|mp4|divx|xvid)$\""    
    files = `#{command}`
end

files.each_line do |i|
i = i.strip
filename = i.split("/").last
print "Checking #{i}.."
STDOUT.flush
for nothing in 1...10
    print "."
    STDOUT.flush
end
STDOUT.flush

    ffcommand = "ffmpeg -i \"#{i}\" 2>&1"

    tccommand = "tcprobe -i \"#{i}\" 2>&1"


ffinfo = `#{ffcommand}`
tcinfo = `#{tccommand}`
ffbad = ffinfo.include?("Invalid data found") 
tcbad = tcinfo.include?("failed to probe source")
if(ffbad && tcbad)
     print "Bad!"
     videos << i
     File.open(local_filename, 'a') {|f| f.puts i }
 elsif(ffbad)
       print "Bad in FFMPEG!"
    File.open("ffmpeg.#{local_filename}", 'a') { |f| f.puts i}
 elsif(tcbad)
       print "Bad in TCPROBE!"
  File.open("tc.#{local_filename}", 'a') { |f| f.puts i}
     else
     print "Ok!"
 end
 print "\n"
 STDOUT.flush
     
  
end


puts "List of bad files"
videos.each do |v|
  puts v
end
