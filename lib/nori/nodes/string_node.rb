class Nori
  module Nodes
    class StringNode < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value.to_s.strip
        @attributes = attributes
        @options = opts
        super(@value)
      end

      def render
        self
      end
    end
  end
end
