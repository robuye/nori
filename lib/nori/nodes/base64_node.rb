class Nori
  module Nodes
    class Base64Node < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(value.unpack('m').first)
      end

      def render
        self
      end
    end
  end
end
