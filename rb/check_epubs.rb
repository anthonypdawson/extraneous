#!/usr/bin/ruby

args = ARGV
directory = ARGV.first
local_filename = "#{directory}/bad_epubs.txt"
if !File.exist?(local_filename)
   File.open(local_filename, "w+").close
end
deleteFile = false
confirmed = !deleteFile
puts "Checking in #{directory}"
(Dir.glob("#{directory}/**/*.epub") + Dir.glob("#{directory}/*.epub")).each do |file|
  puts "unzip -l \"#{file}\""
  status = IO.popen("unzip -l \"#{file}\" 2>&1")  
  bad_zip = false
  status.readlines.each{|l| bad_zip = true if l.include?("End-of-central-directory")}
  status.close
  p $?
  #g = STDIN.gets
  if($?.exitstatus > 0 && bad_zip)
    puts status
    puts "Bad epub detected.."
    #STDIN.gets
    if(deleteFile)
      puts "Delete? y/[N]"
      #foo = STDIN.gets
      foo = "y"
      puts foo
      confirmed = foo.strip.downcase.include? "y"
      puts confirmed
    end
    if(confirmed)
      puts "Adding book to list of bad files"
      File.open(local_filename, 'a') {|f| f.puts file }
      puts "Deleting book"
      if(deleteFile) 
        puts system("sudo rm \"#{file}\"")
      end
    end
  else
    puts "File looks good"
  end
  puts
  continue = 'y'#gets
  if(continue.include?"f")
    break;
  end
end
