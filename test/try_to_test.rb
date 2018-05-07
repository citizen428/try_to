# frozen_string_literal: true

require 'test_helper'

describe Kernel do
  describe '#try_to' do
    describe 'default behavior' do
      it 'returns nil when no block is provided' do
        assert_nil try_to
      end

      it 'returns nil when an empty block is provided' do
        assert_nil(try_to {})
      end

      it "doesn't catch unspecified exceptions" do
        klass = Class.new do
          def foo
            raise
          end
        end

        assert_raises(RuntimeError) do
          try_to { klass.new.foo }
        end
      end

      it 'handles specified exceptions by returning nil' do
        assert_nil(try_to { Object.new.foo })
      end

      it 'handles chained calls' do
        klass = Class.new do
          def self.foo
            self
          end

          def self.boo
            'boo'
          end
        end
        assert_equal(try_to { klass.foo.boo }, 'boo')
      end

      it "doesn't raise exceptions in chain calls" do
        klass = Class.new do
          def self.foo
            self
          end

          def self.boo
            self
          end
        end

        assert_nil(try_to { klass.foo.koo.too })
        assert_nil(try_to { klass.foo.too.koo })
      end

      it 'can add exceptions at runtime' do
        assert_raises(ZeroDivisionError) do
          try_to { 1 / 0 }
        end

        TryTo.add_exception(ZeroDivisionError)

        assert_nil(try_to { 1 / 0 })

        TryTo.reset_exceptions!
      end
    end

    describe 'handlers' do
      it 'uses a default handler' do
        TryTo.default_handler = ->(e) { e.class }
        assert_equal(try_to { Object.new.foo }, NoMethodError)
        TryTo.default_handler = nil
      end

      it 'uses exception class specific handlers' do
        TryTo.add_handler(TypeError, ->(e) { puts e.class })
        assert_output(/TypeError/) { try_to { raise TypeError } }
        TryTo.remove_handler!(TypeError)
      end

      it 'can specify a handler on the fly' do
        assert_equal(try_to(42) { Object.new.foo }, 42)
      end
    end
  end
end
