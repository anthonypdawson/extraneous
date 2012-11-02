require 'open3'

Open3.popen3("ls", "-l") do |i,o,e,t|
  puts o.read
end
