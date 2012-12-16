#!/bin/env ruby
require 'digest/md5'

class Node
  
  attr_reader :hash, :children

  def self.create(file, offset, size, verbose=false)
    puts "Call to Node.create #{offset}:#{size} of #{File.size(file)}" if verbose
    n = Node.new [], verbose
    n.generate_hash(IO.read(file, size, offset))
    n.log n.hash
    @chunk = {:file => file, :offset => offset, :size => size}
    n
  end

  def self.create_parent(nodes, verbose=false)
    puts "Call to node.create_parent" if verbose
    puts "Using #{nodes.map{|n| n.hash}.join(' ')}" if verbose
    node = Node.new(nodes, verbose)
    child_hashes = nodes.map{|n| n.hash }
    node.log "Parent hash = #{child_hashes.join('-')}"
    node.generate_hash(child_hashes.join(""))    
    node
  end

  def initialize(children = [], verbose=false)
    @verbose = verbose   
    log "Received #{children.length} children" if children != []
    @children = children   
  end

  def log (message)
      puts message if @verbose
  end

  def generate_hash(data)
    begin
      @hash = Digest::MD5.hexdigest(data)
    rescue Exception => e
      if data.nil?
        log "Got nil data for this chunk"
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

  def get_bad_nodes(node, bad_nodes)
    if !compare(node)
        bad_nodes << @children 
    else
    
        @children.each_index do |i|
          bad_nodes = @children[i].get_bad_nodes(node.children[i], bad_nodes)
         end			     
    end
    return bad_nodes
  end

  def nodes
    @children
  end

  def chunks
    if @chunk.nil?
      return @children.select {|c| c.chunks }
    end

    @chunk
  end

end


