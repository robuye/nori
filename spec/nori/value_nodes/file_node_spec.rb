require 'spec_helper'

describe Nori::Nodes::FileNode do
  let(:decoded_value) { 'Input' }
  let(:encoded_value) { 'SW5wdXQ=' }
  let(:attributes) { { 'name' => 'original.jpg', 'content_type' => 'application/octet-stream' } }
  let(:node) { described_class.new(encoded_value, attributes) }

  it "can have attributes" do
    node.attributes.should == attributes
  end

  it "returns raw input through #value method" do
    node.value.should == encoded_value
  end

  it "delegates undefined method to String" do
    node.render.should respond_to(:closed?)
  end

  describe "#render" do
    it "returns decoded string" do
      node.render.read.should == decoded_value
    end
  end

  describe "#original_filename" do
    it "returns value from attributes" do
      node.original_filename.should == attributes['name']
    end
  end

  describe "#content_type" do
    it "returns value from attributes" do
      node.content_type.should == attributes['content_type']
    end

    it "returns 'application/octet-stream' if nothing is set in attributes" do
      node = described_class.new('xxx', {})
      node.content_type.should == 'application/octet-stream'
    end
  end
end
