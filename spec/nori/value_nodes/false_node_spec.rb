require 'spec_helper'

describe Nori::Nodes::FalseNode do
  let(:node) { described_class.new(false, {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should be false
  end

  it "delegates undefined method to FalseClass" do
    node.render.should respond_to(:&)
  end
end
