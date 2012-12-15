require 'node.rb'

class Hashtree

  attr_reader :node, :file, :chunk_size

  def Hashtree.create(file, verbose=false)
      return new Hashtree file, 1024, verbose
  end
  def initialize(file, chunk_size=1024, verbose=false)
    @file = file
    @chunk_size = chunk_size
    @file_size = File.size(file)
    @verbose = verbose
    log "Using file #{@file} with a chunk size of #{@chunk_size}"
  end

  def log (message)
      puts message if @verbose
  end

  def generate_tree
    offset = 0
    nodes = []
    log "Total size of file: #{@file_size}"
    chunk_size = @chunk_size
    begin
      chunk_size = @file_size - offset if (offset + @chunk_size) > @file_size
      nodes << Node.create(@file, offset, @chunk_size)
      offset += @chunk_size + 1
    end while offset < File.size(@file)
    @nodes = nodes
    log "Created #{@nodes.length} nodes"
    begin
      nodes = build_parents(nodes)
    end while nodes.length != 1
    @node = nodes[0]
  end

  def hash
      node.hash
  end

  def build_parents(nodes)
    if nodes.length == 1
      nodes.first
    end

    parents = []
    nodes.each_slice(2) do |npair|
      if !npair[1].nil?
        log "Node pair: #{npair.first.hash}, #{npair.last.hash}"
        log "Going to call Node.create_parent"
        #n = Node.create_parent(npair)
        #p = Node.new npair
        #p.generate_hash npair.map{|n| n.hash}.join
        p = Node.create_parent npair
        log p.hash
        log p.children.map {|n| n.hash }
        #parents << Node.create_parent([nodes[i-1], nodes[i]])
        parents << p
        log "Created parent ##{parents.length} - #{parents.last.hash}"
      else
        parents << npair.first
        log "Last node"
      end
    end

    puts "Parent count: #{parents.length}"

    parents
  end

end
