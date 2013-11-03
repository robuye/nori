require 'spec_helper'

describe Nori::Nodes::DateTimeNode do
  let(:node) { described_class.new('2013-07-20 11:00:01:50', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == {attribute: 'value'}
  end

  it "delegates undefined methods to String" do
    node.should respond_to(:iso8601)
  end

  it "returns raw input through #value method" do
    node.value.should == '2013-07-20 11:00:01:50'
    node.value.should be_instance_of(String)
  end
end
