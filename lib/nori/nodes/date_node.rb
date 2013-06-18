class Nori
  module Nodes
    class DateNode < DelegateClass(Date)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(Date.parse(value))
      end

      def render
        self
      end
    end
  end
end
