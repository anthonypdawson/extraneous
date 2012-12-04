class ArgParser
  
  def self.parse(argv, deliminator="=")
    arg_dict = {}
    argv.each do |arg|
      k, v = arg.split(deliminator)
      arg_dict[k.to_sym] = v
      puts k
      puts v
    end
    return arg_dict
  end

end
