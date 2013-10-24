require 'spec_helper'

describe Kernel do
  describe "#try_to" do
    let(:obj) { Object.new }

    it "does nothing when no block is provided" do
      try_to.should be_nil
    end

    it "doesn't catch unspecified exceptions" do
      class A; def foo; raise "test exception" end end
      expect do
        try_to { A.new.foo }
      end.to raise_error(RuntimeError, "test exception")
    end

    it "doesn't raise NoMethodError" do
      expect{ try_to{ obj.foo } }.to_not raise_error(NoMethodError)
    end

    it "returns nil by default" do
      result = try_to { obj.foo }
      result.should be_nil
    end

    it "handles chained calls" do
      def obj.foo; self end
      def obj.boo; "boo" end
      try_to{ obj.foo.boo }.should == 'boo'
    end

    it "doesn't raise exceptions in chain calls" do
      def obj.foo; self end
      def obj.koo; self end
      expect{ try_to{ obj.foo.koo.too }}.to_not raise_error(NoMethodError)
      expect{ try_to{ obj.foo.too.koo }}.to_not raise_error(NoMethodError)
    end

    it "can add exceptions at runtime" do
      expect do
        try_to { 1/0 }
      end.to raise_error(ZeroDivisionError)

      TryTo.exceptions << ZeroDivisionError

      expect do
        try_to { 1/0 }
      end.to_not raise_error(ZeroDivisionError)
    end

    it "uses another handler" do
      TryTo.handlers[TypeError] = lambda { |e| puts e }
      TryTo.exceptions << TypeError
      $stdout.should_receive(:puts)
      try_to { raise TypeError }
    end

    it "can specify a handler on the fly" do
      try_to(42) do
        obj.foo
      end.should == 42
    end
  end
end
