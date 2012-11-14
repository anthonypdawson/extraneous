require 'digest/md5'

class Node
  
  attr_reader :hash, :children

  def self.create(file, offset, size)
    puts "Call to Node.create"
    n = Node.new
    n.generate_hash(IO.read(file, size, offset))
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
    puts "Received #{children.length} children"
    @children = children   
  end


  def generate_hash(data)
    @hash = Digest::MD5.hexdigest(data)
  end

end


