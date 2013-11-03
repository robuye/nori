require 'spec_helper'

describe Nori::Nodes::NilNode do
  let(:node) { described_class.new('', {attribute: 'value'}) }

  it "can have attributes" do
    node.attributes.should == { attribute: 'value' }
  end

  it "returns raw input through #value method" do
    node.value.should == ''
  end

  describe "#render" do
    it "returns self (nil) when attributes are missing" do
      described_class.new('', {}).render.should be_nil
    end

    #This is hack for backward compatibility, should be changed imo
    it "returns hash of prefixed attributes" do
      node.render.should == {'@attribute' => 'value'}
    end
  end

  describe "#nil?" do
    it "returns true" do
      node.nil?.should be true
    end
  end
end
