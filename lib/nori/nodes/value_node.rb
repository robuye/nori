class Nori
  module Nodes
    class ValueNode
      attr_reader :value

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
      end
    end
  end
end
