require 'spec_helper'

describe Nori::XmlUtilityNode do
  let(:node) { described_class.new('tag_name', { attribute: 'value' }, config) }
  let(:config) { double('Config').as_null_object }

  describe "#add_child" do
    it "adds a child(nested) node" do
      nested = double('Nested')
      node.add_child(nested)
      node.nested_nodes.should include(nested)
    end
  end

  describe "#add_text" do
    it "adds value node to nested nodes" do
      node.add_text(' value ')
      node.nested_nodes.should have(1).element
    end
  end

  describe "#render" do
    let(:engine) { double('engine').as_null_object }

    it "delegates rendering to XML engine" do
      Nori::Rendering::XML.should_receive(:new).and_return(engine)
      node.render
    end

    context "when node has attribute type=array" do
      let(:node) { described_class.new('tag_name', { 'type' => 'array' }, config) }

      it "renders content using Array engine" do
        Nori::Rendering::Array.should_receive(:new).and_return(engine)
        node.render
      end
    end

    context "when has value and composite nested nodes" do
      before(:each) do
        node.add_child(double('Composite'))
        node.add_text('some text')
      end

      it "it renders content as HTML" do
        Nori::Rendering::HTML.should_receive(:new).and_return(engine)
        node.render
      end
    end

    context "when has more than 1 text node" do
      before(:each) do
        node.add_text('some text')
        node.add_text('some text')
      end

      it "renders content as HTML" do
        Nori::Rendering::HTML.should_receive(:new).and_return(engine)
        node.render
      end
    end

    context "when has only text node" do
      before(:each) { node.add_text('some text') }

      it "renders content as XML" do
        Nori::Rendering::XML.should_receive(:new).and_return(engine)
        node.render
      end
    end

    context "when has only composite node without text" do
      before(:each) { node.add_child(double('Composite')) }

      it "renders content as XML" do
        Nori::Rendering::XML.should_receive(:new).and_return(engine)
        node.render
      end
    end
  end

  describe "#to_s" do
    it "prints the node as 'HTML' string" do
      node.add_text('some text value')
      node.to_s.should == '<tag_name attribute="value">some text value</tag_name>'
    end

    it "prints the node with nested nodes correct" do
      node2 = described_class.new('nested_tag_name', { attribute: 'value' }, config)
      node.add_child(node2)
      node.add_text('some text val')
      node.to_s.should == '<tag_name attribute="value"><nested_tag_name attribute="value"></nested_tag_name>some text val</tag_name>'
    end
  end
end
