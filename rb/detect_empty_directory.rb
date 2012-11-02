#!/usr/bin/ruby

dir = ARGV[0]
dir = "\"#{dir}*\""
puts dir
Dir.glob(dir).each do |f|
  puts f
     if(File.directory?(f))
       puts f
       files = Dir.glob("\"#{f}/*.{mkv,avi,mpg,mp4,iso,ts}\"")
       puts files
        if(files.length < 1)          
          puts "No videos"
          puts files
          puts Dir.glob(f + "/*")
          puts
        end
     end
end
