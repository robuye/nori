class Nori
  module Nodes
    class TrueNode < DelegateClass(TrueClass)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(true)
      end

      def render
        self
      end
    end
  end
end
