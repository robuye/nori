class Nori
  module Nodes
    class DateTimeNode < ValueNode
      def render
        DateTime.parse(@value)
      end
    end
  end
end
