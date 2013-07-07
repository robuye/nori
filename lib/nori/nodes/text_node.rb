class Nori
  module Nodes
    class TextNode < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(@value)
      end

      def render
        if value.length == 0
          NilNode.new(value, attributes).render
        else
          self
        end
      end
    end
  end
end
