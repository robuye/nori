class Nori
  module Nodes
    class TrueNode < DelegateClass(TrueClass)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(true)
      end

      def render
        self
      end
    end
  end
end
