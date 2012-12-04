require 'digest/md5'

class Node
  
  attr_reader :hash, :children

  def self.create(file, offset, size)
    puts "Call to Node.create #{offset}:#{size} of #{File.size(file)}"
    n = Node.new
    n.generate_hash(IO.read(file, size, offset))
    puts n.hash
    n
  end

  def self.create_parent(nodes)
    puts "Call to node.create_parent"
    puts "Using #{nodes.map{|n| n.hash}.join(' ')}"
    node = Node.new(nodes)
    child_hashes = nodes.map{|n| n.hash }
    puts "Parent hash = #{child_hashes.join('-')}"
    node.generate_hash(child_hashes.join(""))    
    node
  end

  def initialize(children = [])   
    puts "Received #{children.length} children" if children != []
    @children = children   
  end


  def generate_hash(data)
    begin
      @hash = Digest::MD5.hexdigest(data)
    rescue Exception => e
      if data.nil?
        puts "Got nil data for this chunk"
      else
        puts "Exception occurred during chunk hashing"
        puts "Data: #{data}"
        puts e.inspect
        puts e.backtrace
      end
    ensure
      @hash = Digest::MD5.hexdigest("") if @hash.nil? and data.nil?
    end    
  end

  def compare(node)
    @hash == node.hash
  end

end


