class Nori
  module Nodes
    class IntegerNode < DelegateClass(Integer)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(Integer(value))
      end

      def render
        self
      end
    end
  end
end
