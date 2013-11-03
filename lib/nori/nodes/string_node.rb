class Nori
  module Nodes
    class StringNode < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value.to_s
        @attributes = attributes
        super(@value.strip)
      end

      def render
        self
      end
    end
  end
end
