load 'database.rb'
load 'dupe.rb'
load 'file_groups.rb'
SLEEP_TIME=1.0/24.0
#MAX_SIZE = 1000000000
MAX_SIZE = -1
class Scanner
  
  def initialize(paths)
    @paths = paths
  end

  def log message
    puts "Scanner: #{message}"
  end

  def log_exception e, message
    log message
    log e.message
    log e.backtrace
  end

  def scan
    @paths.each {|p| scan_path p }
  end

  def collection
    @collection = FileGroup.new if @collection.nil?
    @collection
  end

  def load
    collection.load
  end

  def scan_path(root)
    root = root + "/" if !root.end_with?"/"
    if !File.readable?root
      log "Path not readable #{root}"
      return
    end
    begin
      Dir.foreach(root) do |p|
        scan_entry root, p
      end
    rescue => e
      log_exception e, "Exception caught in scan_path"
    ensure
      sleep 0.1
    end
  end

  def scan_entry root, p
    begin
      path = root + p
      log "Scanning #{path}"
      is_dir = File.directory?path
      to_scan = need_to_scan?path,is_dir
      log "need_to_scan returned #{to_scan}"
      if !to_scan
        if !is_dir
          d = collection.get_file path
          puts "Checking if file needs updating"
          need_update = need_to_update?d
          if need_update
            log "Sending file to update_dupe"
            update_dupe d
          end
          log "File complete #{d.to_s}"
        end
        log "Skipping entry #{path}"
        return
      end
      if is_dir
        scan_path path
      else
        scan_file path
      end
    rescue => e
      log_exception e, "Exception caught in scan_path Dir.foreach for #{path}"
    ensure
      sleep 0.1
    end
  end

  def need_to_update? d
    return d.need_to_update? if d.kind_of?Dupe
    if !collection.has_path?d
      return false
    end
    d = collection.load_file d if !d.kind_of?Dupe
    log "File loaded, updating entry if file is missing size or hash"
    !d.has_hash? || !d.has_size?
  end

  def need_to_scan? path, is_dir=false
    if is_dir
      fragments = path.split("/")
      if fragments.length == 0 || fragments.last == '.' || fragments.last == '..'
        log "Skipping . or .."
        return false
      end
      return true
    end
    if !File.exist?path
      log "File doesn't exist, skipping"
      return false
    end
    if File.symlink?path
      log "File is symlink, skipping"
      return false
    end
    if !collection.has_path?path
      log "File doesn't exist in DB, need to scan"
      return true
    end
    log "Path exists in DB, checking if file needs update"
    return need_to_update?path
  end

  def scan_file path
    if collection.has_path?path
      puts "In collection, skipping"
    else 
      d = Dupe.new(:path => path)
      if MAX_SIZE > -1 && !MAX_SIZE.nil? && d.size >= MAX_SIZE
        puts "Skipping due to large size:  #{d.pretty_size}"
        return
      end
      add_file d
    end
  end

  def add_file file
    collection.add_file file unless has_path?file.path
  end

  def has_path? p
    collection.has_path?p
  end

  def size_hash
    @size_hash = {} if @size_hash.nil?
    @size_hash
  end

  def add_dupe(d)
    size_hash[d.size] = [] if size_hash[d.size].nil?
    size_hash[d.size] << d
  end

  def get_dupes(by)
    collection.dupe_files by
  end

  def update_dupes order_by=nil, dir=nil
    dupes = collection.dupe_files_by_hash order_by, dir
    collection.update_files dupes
  end

  def update_dupe dupe
    collection.update_files [dupe]
  end
  def update_scan
    collection.hash_dupe_sizes
  end
end


