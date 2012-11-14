
require 'hash_tree.rb'

if !ARGV[0].nil?
  file = ARGV[0]
else
  puts "Usage: #{File.basename($0)} file"
  exit
end

g = Hashtree.new file

g.generate_tree
