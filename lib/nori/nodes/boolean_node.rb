class Nori
  module Nodes
    class BooleanNode < ValueNode
      def render
        @value.blank? ? false : (@value.downcase.strip != 'false')
      end
    end
  end
end
