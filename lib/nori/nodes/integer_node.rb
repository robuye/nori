class Nori
  module Nodes
    class IntegerNode < ValueNode
      def render
        @value.blank? ? nil : @value.to_i
      end
    end
  end
end
