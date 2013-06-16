class Nori
  module Nodes
    class DateNode < ValueNode
      def render
        Date.parse(@value)
      end
    end
  end
end
