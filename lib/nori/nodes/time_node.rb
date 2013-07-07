class Nori
  module Nodes
    class TimeNode < DelegateClass(Time)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(Time.parse(value))
      end

      def render
        self
      end
    end
  end
end
