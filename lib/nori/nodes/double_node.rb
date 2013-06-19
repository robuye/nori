class Nori
  module Nodes
    class DoubleNode < DelegateClass(Float)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(value.to_f)
      end

      def render
        self
      end
    end
  end
end
