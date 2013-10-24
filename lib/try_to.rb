module TryTo
  class << self
    attr_accessor :exceptions, :default_handler, :handlers
    private :handlers=
  end

  def self.add_handler(exception, handler)
    self.handlers.merge!(exception => handler)
  end

  self.handlers = {}
  self.exceptions = [NoMethodError]
end

module Kernel
  def try_to(handler = nil, &block)
    block.call if block
  rescue *(TryTo.exceptions | TryTo.handlers.keys) => e
    handler = [
               handler,
               TryTo.handlers[e.class],
               TryTo.default_handler
              ].compact.first
    handler.respond_to?(:call) ? handler.call(e) : handler
  end

  private :try_to
end
