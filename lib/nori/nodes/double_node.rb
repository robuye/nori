class Nori
  module Nodes
    class DoubleNode < DelegateClass(Float)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(value.to_f)
      end

      def render
        self
      end
    end
  end
end
