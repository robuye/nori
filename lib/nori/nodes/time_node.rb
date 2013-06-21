class Nori
  module Nodes
    class TimeNode < DelegateClass(Time)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(Time.parse(value))
      end

      def render
        self
      end
    end
  end
end
