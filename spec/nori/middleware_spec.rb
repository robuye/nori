require 'spec_helper'

describe Nori::Middleware do
  let(:config)     { double }
  let(:middleware) { described_class.new(config) }

  describe "#attributes" do
    it "yields a builder to block if block given" do
      middleware.attributes {|builder| builder.should be_a(::Middleware::Builder)}
    end

    context "when used with legacy config" do
      let(:config) { double(Nori::Config, delete_namespace_attributes: true) }

      it "includes Undasherize middleware by default" do
        stack = middleware.attributes.send(:stack).flatten.compact
        stack.should include(Nori::Middleware::Attributes::Undasherize)
      end

      it "includes RemoveNamespaceAttributes if enabled in config" do
        stack = middleware.attributes.send(:stack).flatten.compact
        stack.should include(Nori::Middleware::Attributes::RemoveNamespace)
      end

      it "does not include RemoveNamespaceAttributes if disabled in config" do
        config.stub(delete_namespace_attributes: false)
        stack = middleware.attributes.send(:stack).flatten.compact
        stack.should_not include(Nori::Middleware::Attributes::RemoveNamespace)
      end
    end
  end

  describe "#tags" do
    it "yields a builder to block if block given" do
      middleware.tags {|builder| builder.should be_a(::Middleware::Builder)}
    end

    context "when used with legacy config" do
      let(:custom_proc) { proc {|i| i} }
      let(:config) { double(Nori::Config, strip_namespaces: true, convert_tags_to: custom_proc) }

      it "includes Undasherize middleware by default" do
        stack = middleware.tags.send(:stack).flatten.compact
        stack.should include(Nori::Middleware::Tags::Undasherize)
      end

      it "includes StipNamespace if enabled in config" do
        stack = middleware.tags.send(:stack).flatten.compact
        stack.should include(Nori::Middleware::Tags::StripNamespace)
      end

      it "includes convert_tags_to proc if set in config" do
        stack = middleware.tags.send(:stack).flatten.compact
        stack.should include(custom_proc)
      end

      it "does not include convert_tags_to if not set in config" do
        config.stub(convert_tags_to: nil)
        stack = middleware.tags.send(:stack).flatten.compact
        stack.should_not include(custom_proc)
      end

      it "does not include StripNamespace if disabled in config" do
        config.stub(strip_namespaces: false)
        stack = middleware.tags.send(:stack).flatten.compact
        stack.should_not include(Nori::Middleware::Tags::StripNamespace)
      end
    end
  end
end
