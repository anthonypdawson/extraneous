#!/usr/bin/ruby

require 'digest/md5'
class HashDupeFinder

  def initialize(directory)
    @hashMap = {}
    directory += "/" if !directory.end_with?"/"
    @directory = directory
    setup_list_file
  end

  def setup_list_file
    @dupeFile = "#{@directory}new_dupelist.txt"      
    puts "Writing duplicates to #{@dupeFile}"
    gets
  end

  def hash_file(file)
    Digest::MD5.hexdigest(File.read(file))
  end

  def scan_files(dir=@directory)
    dir += "/" if !dir.end_with?"/"
    puts "scanning " + dir
    Dir.glob(dir + "*").each do |d|
      #sleep(1.0/24.0)
      if File.directory?d
        puts "Found directory\t#{d}"
        scan_files(d)
      else
        puts "Found file\t#{d}"
        hash = hash_file(d)
        puts hash
        if @hashMap.has_key?hash and !@hashMap[hash].nil? and !@hashMap[hash][0].nil?
          if !@hashMap[hash].include?d
            existing_files = @hashMap[hash]
            puts "Duplicate file!"
            puts "new file\t#{d}"
            puts "existing file(s) count: #{existing_files.length} \t " + existing_files.join("\t")
            @hashMap[hash] << d
            #write_duplicate(@hashMap[hash], hash)
          end
        else
          puts "New file"
          @hashMap[hash] = [d]
        end
      end
    end
  end
  
  def write_file
    @hashMap.keys.each do |k|
      write_duplicate(@hashMap[k], k)
    end
  end

  def write_duplicate(files, hash)    
    puts "Writing duplicate files to text"
    File.open(@dupeFile, "a"){ |f| 
      f << hash + "\n"
      f << files.join("\n")
      f << "\n\n"
    }
  end

end

d = HashDupeFinder.new("/home/ayd/Public/Downloads/ebooks/")
d.scan_files
d.write_file
#d.scan_files"/mnt/data/Public/Downloads/ebooks/unsorted/"
