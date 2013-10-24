class TryIt
  class << self
    attr_accessor :exceptions, :handler
  end

  self.exceptions = [NoMethodError]
  self.handler = lambda { |_| nil } # like Object#try in Rails
end

class Object
  def tryit(*args, &block)
    if args.empty? && block_given?
      instance_eval(&block)
    else
      send(*args, &block)
    end
  rescue *TryIt.exceptions => e
    TryIt.handler.call(e)
  end
end
