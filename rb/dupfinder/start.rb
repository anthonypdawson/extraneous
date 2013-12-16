load 'dupfinder.rb'
@commands = ["s","u","p"]
def check_command cmd
  @commands.each do |c|
    c = c + " "
    if  cmd.start_with?c
    	puts "Good command"
    end
  end
end

paths = []
path = "/mnt/zfs/Public/"
if !ARGV.nil? && ARGV.length > 0
  paths = ARGV
else 
  paths << path
end
s = Scanner.new(paths)


input = ""
while input != "q" && input != "quit"
  putc ">"
  input = gets.chomp.downcase
  check_command input  
end

#s.scan
#f = s.update_dupes QUERY_COLUMN[:size], 'desc'
#s.get_dupes QUERY_COLUMN[:hash]
#s.load
#s.scan
#s.update_scan
#s.collection.put_stats

=begin
puts s.size_hash

s.size_hash.keys.each do |k|
  files = s.size_hash[k]
  if files.length > 1
    puts k.to_s + " has files: " + files.length.to_s
    files.each do |f|
      puts "#{f.path} hash: #{f.hash}"
    end
    
  end
end
=end
