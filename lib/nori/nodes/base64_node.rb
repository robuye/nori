class Nori
  module Nodes
    class Base64Node < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(value.unpack('m').first)
      end

      def render
        self
      end
    end
  end
end
