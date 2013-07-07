class Nori
  module Nodes
    class IntegerNode < DelegateClass(Integer)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(Integer(value))
      end

      def render
        self
      end
    end
  end
end
