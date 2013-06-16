class Nori
  module Nodes
    class TextNode < ValueNode
      def render
        text = StringWithAttributes.new(@value.strip)
        return nil if text.length == 0
        text.attributes = @attributes
        text
      end
    end
  end
end
