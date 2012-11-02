#!/usr/bin/ruby
$LOAD_PATH << './lib'
require 'argument_controller.rb'


def deleteFiles(fileList, reallyDelete)
  if !File.exist?(fileList)
    blowUp("#{fileList} : File doesn't exist")
  end
  File.open(fileList).read.each_line do |i|
    file = "./#{i}".strip
    
    if fileExists(file, false)
      puts "#{file} : File already exists, continuing to next file"
      next
    end

    printf("%1s", file)
    print "\t"
    print File.size(file)
    print " bytes"
    STDOUT.flush
    puts
    print "\tDeleting #{file}"
    STDOUT.flush  
    puts "... not really! use -D to override..\n" if reallyDelete
    File.delete(file) unless !reallyDelete
    print "\t\t\t\t--Done!"
    STDOUT.flush
    puts "\n\n"
  end
end

def blowUp(message)
  puts message
  exit
end

def fileExists(file, blowup = false)
  if !File.exist?(file)
    blowUp("#{file} : Doesn't exist") unless !blowup
    false
  end
  true
end

error1 = "You must supply a line delimited file of filenames to remove"

a = ArgvController.new(2, [error1], ARGV, 1)

args = a.process

if args.nil? or args.first.nil?
  blowUp("Exiting..")
end

fileList = args.first

reallyDelete = !args[1].nil? and args[1] == "-D"

deleteFiles(fileList, reallyDelete)
