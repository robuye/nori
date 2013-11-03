require 'spec_helper'

describe Nori::Nodes::BooleanNode do
  let(:node) { described_class }
  describe "#new" do
    it "returns FalseNode for input 'false'" do
      node.new('false', {}).should be_instance_of(Nori::Nodes::FalseNode)
    end

    it "returns FalseNode for input '0'" do
      node.new('0', {}).should be_instance_of(Nori::Nodes::FalseNode)
    end

    it "returns TrueNode for input 'true'" do
      node.new('true', {}).should be_instance_of(Nori::Nodes::TrueNode)
    end

    it "returns TrueNode for input '1'" do
      node.new('1', {}).should be_instance_of(Nori::Nodes::TrueNode)
    end

    it "downcase input" do
      node.new('False', {}).should be_instance_of(Nori::Nodes::FalseNode)
      node.new('True', {}).should be_instance_of(Nori::Nodes::TrueNode)
    end

    it "raises exception on invalid input" do
      expect {node.new('invalid', {})}.
        to raise_error('Invalid input for BooleanNode')
    end
  end
end
