require 'spec_helper'

describe Nori::Nodes::IntegerNode do
  let(:node) { described_class.new('10', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should == '10'
  end

  it "delegates undefined method to Integer" do
    node.render.should respond_to(:even?)
  end

  describe "#render" do
    it "returns integer value" do
      node.render.should == 10
    end
  end
end
