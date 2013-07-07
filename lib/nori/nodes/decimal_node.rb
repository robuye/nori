class Nori
  module Nodes
    class DecimalNode < DelegateClass(BigDecimal)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(BigDecimal.new(value))
      end

      def render
        self
      end
    end
  end
end
