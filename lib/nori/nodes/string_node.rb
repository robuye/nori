class Nori
  module Nodes
    class StringNode < ValueNode
      def render
        @value.to_s
      end
    end
  end
end
