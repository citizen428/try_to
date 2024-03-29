# frozen_string_literal: true

module TryTo
  @handlers = {}
  @exceptions = [NoMethodError]

  class << self
    attr_accessor :default_handler
    attr_reader :exceptions, :handlers

    def add_handler(exception, handler)
      @handlers.tap { |h| h[exception] = handler }
    end

    def remove_handler!(exception)
      @handlers.tap { |h| h.delete(exception) }
    end

    def add_exception(exception)
      @exceptions << exception
    end

    def remove_exception!(exception)
      @exceptions -= [exception]
    end

    def reset_exceptions!
      @exceptions = [NoMethodError]
    end
  end
end

module Kernel
  private def try_to(handler = nil)
    yield if block_given?
  rescue *(TryTo.exceptions | TryTo.handlers.keys) => e
    handler = handler || TryTo.handlers[e.class] || TryTo.default_handler
    handler.respond_to?(:call) ? handler.call(e) : handler
  end
end
