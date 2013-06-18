class Nori
  module Nodes
    class TextNode < DelegateClass(String)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value.strip
        @attributes = attributes
        @options = opts
        super(@value)
      end

      def render
        if @value.length == 0
          NilNode.new(@value, @attributes, @options).render
        else
          self
        end
      end
    end
  end
end
