require 'spec_helper'

describe Nori::Nodes::StringNode do
  let(:node) { described_class.new(' text xxx ', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should == ' text xxx '
  end

  it "delegates undefined method to String" do
    node.render.should respond_to(:upcase)
  end

  describe "#render" do
    it "strips the returned string" do
      node.render.should == 'text xxx'
    end
  end
end
