#!/usr/bin/ruby

def pretty_size(size)
  divideBy = 2**20
  suffix = "MiB"
  if(size > (divideBy * 1000))
    divideBy = ((divideBy)*1000)
    suffix = "GiB"
  end

  hSize = '%.2f' % ((size).to_f / divideBy)
  return "#{hSize} #{suffix}"
end


totalSize = 0

File.read(ARGV.first).each_line do |file|
  #file = "./#{file}"
  file.strip!
  print file
  print "    "
  STDOUT.flush
  if File.exist?(file)
    size = File.size(file)
    puts pretty_size(size)
    totalSize += size
  end
end
puts pretty_size(totalSize)

