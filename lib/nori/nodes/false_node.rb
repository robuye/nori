class Nori
  module Nodes
    class FalseNode < DelegateClass(FalseClass)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(false)
      end

      def render
        self
      end
    end
  end
end
