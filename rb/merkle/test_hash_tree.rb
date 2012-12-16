
require 'hash_tree.rb'

if !ARGV[0].nil?
  file = ARGV[0]
else
  puts "Usage: #{File.basename($0)} file"
  exit
end

trees = []

ARGV.each do |v|
  g = Hashtree.new v
  g.generate_tree
  trees << g
  puts "Hash for file: #{g.node.hash}"
end

puts trees[0].node.get_bad_nodes(trees[1].node, []).length
if (trees[0].node.children.length <=1)
   puts "Not enough node children"
   exit
end

if (trees.first.hash != trees.last.hash)
   puts "Error, hash mismatch"
end
