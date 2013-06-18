class Nori
  module Nodes
    class DateTimeNode < DelegateClass(DateTime)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(DateTime.parse(value))
      end

      def render
        self
      end
    end
  end
end
