class Nori
  module Nodes
    class TimeNode < ValueNode
      def render
        Time.parse(@value).utc
      end
    end
  end
end
