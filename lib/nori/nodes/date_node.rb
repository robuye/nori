class Nori
  module Nodes
    class DateNode < DelegateClass(Date)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(Date.parse(value))
      end

      def render
        self
      end
    end
  end
end
