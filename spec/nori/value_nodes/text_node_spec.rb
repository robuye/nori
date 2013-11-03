require 'spec_helper'

describe Nori::Nodes::TextNode do
  let(:node) { described_class.new('Input', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == {attribute: 'value'}
  end

  it "delegates undefined methods to String" do
    node.should respond_to(:upcase)
  end

  it "returns raw input through #value method" do
    node.value.should == 'Input'
    node.value.should be_instance_of(String)
  end

  describe '#render' do
    it "returns Nil node if input is empty" do
      node = described_class.new('', {}).render
      node.should be_instance_of(Nori::Nodes::NilNode)
    end

    it "returns self if input is not empty" do
      node.render.should == node
    end
  end
end
