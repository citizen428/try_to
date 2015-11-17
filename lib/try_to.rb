module TryTo
  class << self
    attr_accessor :default_handler
    attr_reader :exceptions, :handlers
  end

  def self.add_handler(exception, handler)
    @handlers.merge!(exception => handler)
  end

  @handlers = {}
  @exceptions = [NoMethodError]
end

module Kernel
  def try_to(handler = nil)
    yield if block_given?
  rescue *(TryTo.exceptions | TryTo.handlers.keys) => e
    handler = [handler,
               TryTo.handlers[e.class],
               TryTo.default_handler].compact.first
    handler.respond_to?(:call) ? handler.call(e) : handler
  end

  private :try_to
end
