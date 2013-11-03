require 'spec_helper'

describe Nori::Nodes::DoubleNode do
  let(:node) { described_class.new('10', { attribute: 'value' }) }

  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should == '10'
  end

  it "delegates undefined method to BigDecimal" do
    node.render.should respond_to(:round)
  end

  describe "#render" do
    it "converts value to float" do
      node.render.should == 10.0
    end
  end
end
