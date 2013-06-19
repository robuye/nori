class Nori
  module Nodes
    class DecimalNode < DelegateClass(BigDecimal)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(BigDecimal.new(value))
      end

      def render
        self
      end
    end
  end
end
