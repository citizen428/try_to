require 'spec_helper'

describe Object do
  describe "#tryit" do
    let(:obj) { Object.new }

    it "doesn't catch unspecified exceptions" do
      class A; def foo; raise "test exception" end end
      expect do
        A.new.tryit{ foo }
      end.to raise_error(RuntimeError, "test exception")
    end

    it "doesn't raise NoMethodError" do
      expect{ obj.tryit{ foo } }.to_not raise_error(NoMethodError)
    end
    it "yields to a provided block" do
      obj.should_receive(:foo)
      obj.tryit{ foo }
    end

    it "sends a method" do
      obj.should_receive(:foo)
      obj.tryit{ foo }
    end

    it "sends a method with arguments" do
      def obj.foo(arg); arg end
      obj.tryit(:foo, "arguments").should == "arguments"
    end

    it "handles chained calls" do
      def obj.foo; self end
      def obj.boo; "boo" end
      obj.tryit{ foo.boo }.should == 'boo'
    end

    it "doesn't raise exceptions in chain calls" do
      def obj.foo; self end
      def obj.koo; self end
      expect{ obj.tryit{ foo.koo.too }}.to_not raise_error(NameError)
    end

    it "catches ZeroDivisionError exception" do
      expect do
        obj.tryit { 1/0 }
      end.to raise_error(ZeroDivisionError)

      TryIt.exceptions << ZeroDivisionError

      expect do
        obj.tryit { 1/0 }
      end.to_not raise_error(ZeroDivisionError)
    end

    it "uses another handler" do
      TryIt.handler = lambda { |e| puts e }
      TryIt.exceptions << TypeError
      $stdout.should_receive(:puts)
      obj.tryit { raise TypeError }
    end
  end
end
