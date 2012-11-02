
#puts "ArgController included"

class ArgvController

  def initialize(argCount, errorMessages, argv, argCountRequired)
    if argCount < 1
      puts "You need an arg count if you want to control args!"
      nil
    end
    argCountRequired = 0 if argCountRequired.nil?
    @required = argCountRequired
    @required = @required - 1 unless @required < 1
    @argCount = argCount
    @errorMessages = errorMessages
    @args = argv
  end

  def process
    if @args.nil? or @args.length < 1
      puts @errorMessages.first
      return nil
    end

    0.upto(@argCount) do |ind|
      if @args[ind].nil? && @required  >= ind
        puts @errorMessages[ind]
        nil         
      end        
    end
    @args
  end

end
