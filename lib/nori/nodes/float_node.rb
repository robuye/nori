class Nori
  module Nodes
    class FloatNode < ValueNode
      def render
        @value.nil? ? nil : @value.to_f
      end
    end
  end
end
