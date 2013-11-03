require 'spec_helper'

describe Nori::Nodes::TimeNode do
  let(:node) { described_class.new('12:01:03', {attribute: 'value'}) }
  
  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should == '12:01:03'
  end

  it "delegates undefined method to Time" do
    node.render.should respond_to(:zone)
  end

  describe "#render" do
    it "returns time" do
      node.render.should == Time.parse('12:01:03')
    end
  end
end
