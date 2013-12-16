load 'dupe.rb'
load 'database.rb'

HASH_LIST_SQL = "select hash from files group by hash having count(*) > 1"
DUPE_HASH_FILES_SQL = "select * from files where hash in (#{HASH_LIST_SQL})"

class FileDb

  attr_reader :table_name, :database_name

  def initialize(db_file, db_name)
    @db_name = db_name
    @db_file = db_file
  end

  def add_file f
    hash = "null"
    hash = "\"#{f.hash}\"" if f.has_hash?
    puts "Adding file: #{f.path}, #{f.pretty_size}"
    get_db.add_row "\"#{f.path}\", #{f.size}, #{hash}"
  end

  def get_db
    open_database
    @db
  end

  def open_database
    @db = Database.new @db_file, "files" if @db.nil?
  end

  def get_file path
    Dupe.load get_db.query("select * from files where path = \"#{path}\"")
  end

  def get_files
    get_db.get_rows
  end

  def load_files
    Dupe.load(get_files)
  end

  def dupe_hash_list
    get_db.query(HASH_LIST_SQL).map{|h| h[0]};
  end

  def dupe_files_by_hash order_by=nil, dir=nil
    sql = DUPE_HASH_FILES_SQL
    sql = "#{sql} order by #{order_by}" unless order_by.nil?
    sql = "#{sql} #{dir}" unless dir.nil?
    file_rows = get_db.query(sql)
    Dupe.load(file_rows)
  end  

  def hash_dupe_sizes
    sizes = get_dupe_sizes
    sizes.each do |size|
      size = size.first
      puts size
      sql = "select * from files where size = #{size} and hash is null;"
      val = get_db.query(sql)
      puts val
      files = Dupe.load(get_db.query(sql))
      files.each {|f| update_hash f }
    end
  end

  def get_dupe_sizes
    sql = "select size from files group by size having count(*) > 1;"
    get_db.query(sql)
  end

  def remove_dupe files, mklink=false
    keep = files.shift
    files.each do |f|
      remove_file f
      make_link keep.path, f.path unless !mklink
    end
  end

  def make_link p1, p2
    File.link(p1, p2)
  end
  def remove_file f
    sql = "delete from files where path = \"#{f.path}\""
    get_db.query(sql)
  end
  
  def update_file f
      if !File.exist?f.path
        puts "File no longer exists. #{f.path}"
        remove_file f
        return
      end
      update_hash f
  end
  def update_hash f
    puts "Update hash #{f.path}"
    begin
      if !File.exist?f.path
        puts "File no longer exists. #{f.path}"
        remove_file f.path
        return
      end
      puts "#{f.path}, #{f.size}, #{f.hash}"
      hash = f.hash
      sql = "update files set hash = '#{hash}' where path = \"#{f.path}\" and hash is null;"
      get_db.query sql
    rescue => e
      puts "Error updating file #{f.path}"
      puts e.message
    end
  end

  def query sql
    get_db.query sql
  end
end
