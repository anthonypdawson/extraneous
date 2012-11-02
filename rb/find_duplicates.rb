#!/usr/bin/ruby

dir = ARGV[0]
if dir.nil? || dir.length == 0
  dir = Dir.getwd
end

names = []
Dir.foreach(dir) do |f|
  next if !File.directory?f || f == "." || f == ".."
  file = f.split("/").last
  newF = file.gsub(/(\.)(?!\s)/," ").split("(").first
  puts "#{file} to #{newF}"
  if !names.include?(newF)
    names << file
  else
    puts "Dupe! #{file}"
  end
end
