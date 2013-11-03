require 'spec_helper'

describe Nori::Nodes::DateNode do
  let(:node) { described_class.new('2013-07-19', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == {attribute: 'value'}
  end

  it "delegates undefined methods to Date" do
    node.should respond_to(:iso8601)
  end

  it "returns raw input through #value method" do
    node.value.should == '2013-07-19'
  end

  describe '#render' do
    it "returns self" do
      node.render.should == node
    end
  end
end
