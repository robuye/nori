class Nori
  module Nodes
    class FalseNode < DelegateClass(FalseClass)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(false)
      end

      def render
        self
      end
    end
  end
end
