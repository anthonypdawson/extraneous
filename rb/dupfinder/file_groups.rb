load 'file_db.rb'

class FileGroup

  def log message
    puts "FileGroup: #{message}"
  end

  def add_file f, add_to_db = true
    if !f.is_a?Dupe
      f = Dupe.new(:path => f)
    end

    files[f.path] = f  if !has_path?f.path
    add_to_size_group f
    add_to_hash_group f if f.has_hash?
    file_db.add_file f if add_to_db
  end

  def load_file path
    sql = "select * from file where path = \"#{path}\""
    row = get_db.query(sql)
    Dupe.load(row)
  end

  def add_files files
    files.each {|f| add_file f }
  end 

  def hash_group
    @hash_group = {} if @hash_group.nil?
    @hash_group
  end

  def size_group
    @size_group = {} if @size_group.nil?
    @size_group
  end

  def add_to_hash_group f
    get_files_for_hash(f.hash) << f
  end

  def add_to_size_group f
    get_files_for_size(f.size) << f
  end

  def add_to_group group, file
    group << file
  end

  def has_hash? hash
    hash_group.has_key?hash
  end

  def has_size? size
    size_group.has_key?size
  end

  def has_path? path
    has_path = files.has_key?path
    log "Path in cache: #{has_path}"
    if !has_path
      f = get_file(path)
      return false if f.nil?
      log "File loaded #{f}.to_s"
      has_path = !f.nil?
      log "Path in DB: #{has_path}"
    end
    return has_path
  end

  def get_file path
    if files.has_key?path
      files[path]
    end

    f = file_db.get_file path

    log "get_file: #{path}. Nil? #{f.nil?}, array? #{f.kind_of?Array}, to_s:  #{f.to_s}"
      
    if !f.nil?  
      if f.kind_of?Array
        if !f.empty?
          log "File is an array and not empty, taking first element"
          f = f[0]
        end
       end
      log "File: is_Dupe?: #{f.kind_of?Dupe}"
      files[path] = f if f.kind_of?Dupe
    end
    f
  end

  def files
    if @files.nil?
      log "@files nil, creating hash"
      @files = {}
    end
    return @files
  end

  def get_files_for_size size
    size_group[size] = [] if size_group[size].nil?
    size_group[size]
  end

  def get_files_for_hash hash
    hash_group[hash] = [] if hash_group[hash].nil?
    hash_group[hash]
  end

  def get_files i
    if i.is_a?Numeric
      collection = hash_group
    else
      collection = size_group
    end
    collection[i] = [] if collection[i].nil?
    collection[i]
  end

  def has_size_dupes?
    size_group.keys.each do |k|
      true if get_files_for_size(k).length > 1
    end
    false
  end

  def load
    file_db.load_files.each do |f|
      add_file f, false
    end
  end

  def load_file path
    file_db.get_file path
  end
  def file_db
    @file_db = FileDb.new("dupes.db", "files") if @file_db.nil?
    @file_db
  end
 
  def update_files files
    files.each do |f|
      file_db.update_file f
    end
  end

  def hash_dupe_sizes
    file_db.hash_dupe_sizes
  end

  def dupe_files(dup_by, order_by=nil)
    case dup_by
    when QUERY_COLUMN[:hash]
      dupe_files_by_hash order_by
    when QUERY_COLUMN[:size]
      dupe_files_by_size order_by
    else
      raise "Invalid query type: #{by}!"
    end
  end

  def dupe_files_by_hash order_by=nil, dir=nil
    file_db.dupe_files_by_hash order_by, dir
  end

  def dupe_files_by_size order_by
    file_db.dupe_files_by_size
  end

  def put_stats
    puts "Size hash keys: #{size_group.keys.length}"
    size_group.keys.each do |k|
      files = size_group[k]
      if files.length > 1
        puts "Size: #{k}, Files: #{files.length}"
        files.each do |f|
          puts "#{f.name} - #{f.hash}"
        end
      end
    end
  end
end

QUERY_COLUMN = {:hash=>"hash", :size=>"size"}
