class Nori
  module Nodes
    class DecimalNode < ValueNode
      def render
        @value.nil? ? nil : BigDecimal(@value.to_s)
      end
    end
  end
end
