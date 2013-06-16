class Nori
  module Nodes
    class DoubleNode < ValueNode
      def render
        @value.nil? ? nil : @value.to_f
      end
    end
  end
end
