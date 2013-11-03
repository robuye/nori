require 'spec_helper'

describe Nori::Nodes::Base64Node do
  let(:decoded_value) { 'Input' }
  let(:encoded_value) { 'SW5wdXQ=' }
  let(:node) { described_class.new(encoded_value, {attribute: 'value'}) }

  it 'can have attributes' do
    node.attributes.should == {attribute: 'value'}
  end

  it 'delegates undefined methods to String' do
    node.should respond_to(:upcase)
  end

  it "returns raw input through #value method" do
    node.value.should == encoded_value
    node.value.should be_instance_of(String)
  end

  describe "#render" do
    it "returns self with decoded string" do
      node.render.should == decoded_value
    end
  end
end
