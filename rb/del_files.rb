File.open("confirmed_bad_list.txt").read.each_line do |i|
  file = "./#{i}".strip
  
  
  printf("%1s", file)
  puts
  print "\t"
  print File.size(file)
  print " bytes"
  STDOUT.flush
  puts
  print "\tDeleting"
  STDOUT.flush
  puts 
  
  puts
  File.delete(file)
  print "\t\t\t\t--Done!"
  STDOUT.flush
  puts
  puts
  puts 
end
