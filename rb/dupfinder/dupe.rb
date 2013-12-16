require 'digest/md5'

class Dupe
  attr_accessor :file_path, :file_name, :file_extension, :file_size, :file_hash

  def Dupe.load(rows)
    files = []
    rows.each do |r|
      path = r[0]
      size = r[1]
      hash = r[2]
      files << Dupe.new(:path => path, :size => size, :hash => hash)
    end

    files
  end

  def initialize(args)
    @file_path = args[:path] unless args[:path].nil?
    @file_size = args[:size] unless args[:size].nil?
    @file_hash = args[:hash] unless args[:hash].nil?
  end

  def init(path)
    @file_path = path
  end

  def init(path, size)
    init(path)
    @file_size = size
  end

  def init(path, size, hash)
    init(path, size)
    @file_hash = hash
  end

  def need_to_update?
    return !has_size? 
  end

  def name
    @file_name = @file_path.split("/").last if @file_name.nil? || @file_name.empty?
    @file_name
  end

  def extension
    @file_extension = name.split(".").last if @file_extension.nil? || @file_extension.empty?
  end

  def path
    @file_path
  end

  def size
    @file_size = File.size(@file_path)  if @file_size.nil?
    @file_size
  end

  def hash
    @file_hash = Digest::MD5.hexdigest(File.read(@file_path)) if @file_hash.nil?
    @file_hash
  end

  def has_hash?
    !@file_hash.nil?
  end

  def has_size?
    !@file_size.nil?
  end

  def pretty_size
    label = "B"
    p_size = size
    if size > 999999999
      p_size = size / 1000000000.0
      label = "GB"
    elsif size > 999999
      p_size = size / 1000000.0
      label = "MB"
    elsif size > 999
      p_size = size / 1000.0
      label = "KB"
    end
    p_size = "%g" % p_size.round(2)
    return "#{p_size}#{label}"
  end

  def to_s
    puts "#{@file_path} #{pretty_size} #{@file_hash}"
  end
end
