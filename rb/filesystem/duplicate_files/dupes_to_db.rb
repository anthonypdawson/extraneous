#!/usr/bin/ruby

require 'digest/md5'
require 'sqlite3'

class HashDupeFinder

  def initialize(directory, database="books.rb")
    @hashMap = {}
    @database = database
    directory += "/" if !directory.end_with?"/"
    @directory = directory
    #puts "Opening db"
    # Create DB here?
    #@db = SQLite3::Database.open(@database)
    #@db.close if @db
    #gets
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
        hash_files = query_db("select * from books where Hash = '#{hash}'")
        if hash_files.length > 0
          hash_files = hash_files.map{|h| h[1] }
          if !hash_files.include?d
            puts "Duplicate file!"
            puts "new file\t#{d}"
            puts "existing file(s) count: #{hash_files.length} \t " + hash_files.join("\t")
            @hashMap[hash] << d
            write_to_database(d, hash, true)
          end
        else
          puts "New file"          
          write_to_database(d, hash)
        end
      end
    end
  end
  
  def write_file
    @hashMap.keys.each do |k|
      write_duplicate(@hashMap[k], k)
    end    
  end

  def query_db(query)
     begin
       @db = SQLite3::Database.open(@database)
       results = @db.execute(query)
     rescue SQLite3::Exception => e
       puts "Exception!"
       puts e
     ensure
       @db.close if @db
       results
     end
  end
  
  def write_to_database(file, hash, is_duplicate=false)
    is_dupe = 0
    is_dupe = 1 if is_duplicate
    query_db("insert into books VALUES('#{hash}', '#{file}', #{is_dupe})")
    query_db("update books set is_dupe = 1 where Hash = '#{hash}' and is_dupe = 0")
  end

  def write_files_to_database(files, hash)
    # this was an older method that needs to be removed once I make sure it's not breaking TODO
      files.each do |f|    
        query_db("insert into books VALUES('#{hash}', '#{f}')")
      end

  end

  # For writing paths to file instead of DB
  def write_duplicate(files, hash)    
    puts "Writing duplicate files to text"
    File.open(@dupeFile, "a") do |f| 
      f << hash + "\n"
      f << files.join("\n")
      f << "\n\n"
    end
    
  end

  def delete_dupes
    count = query_db("select count(distinct Hash) from books")[0][0]
    puts count
    step = 100
    0.step(count, step) do |i|
      puts "Getting next #{step}, #{i} of #{count}"
      hashes = query_db("select Hash from books group by Hash limit #{step} offset #{i}").map{|h| h[0] }
      #puts hashes
      puts '.'
      hashes.each do |h|
        files = query_db("select * from books where Hash = '#{h}'")
        if(files.length > 1)
          puts "Duplicates"
          gets
          process_files(files.map{|f| f[1] })         
        end
        STDOUT.print '.'
      end    
    end
  end


  def process_files(files)
    file_count = files.length
    puts files
    files.map {|file| file if File.exist?file }

    files_found = files.length

    puts "#{files_found} out of #{file_count} were found"

    if(files.length <= 1)
      puts "Duplicates not found, skipping to next entry"
      return
    end

    0.upto(files.length - 1) do |i|
      puts "(#{i+1}) #{files[i]}"
    end

    puts "Choose a file to keep (1):"

    answer = gets.chomp.to_i


    begin
      puts "Please try again"
      answer = gets
    end while !answer.is_a?Fixnum or  answer < 1 or answer > files.length

    puts "File.delete(files[answer-1])"
    gets    
  end

  def write_hash
    File.new("hash.txt","w").write(@hashMap)
  end
end

d = HashDupeFinder.new("/home/ayd/Public/Downloads/ebooks/")
d.scan_files
#d.write_hash
#d.delete_dupes
