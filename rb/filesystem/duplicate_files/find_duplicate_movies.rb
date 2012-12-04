#!/usr/bin/ruby

dir = ARGV[0]
orig = Dir.pwd
if dir.nil? || dir.length == 0
  dir = Dir.getwd
end

dir += "/" unless dir.end_with?"/"
Dir.chdir dir
names = []
Dir.foreach(dir) do |f|
  full_path = dir + f
  next if !File.directory?f || f == "." || f == ".."
  file = f
  newF = file.gsub(/(\.)(?!\s)/," ").split("(").first.downcase
  puts "#{file} to #{newF}"
  if !names.include?(newF)
    names << file
  else
    puts "Dupe! #{file}"
  end
end

Dir.chdir orig
