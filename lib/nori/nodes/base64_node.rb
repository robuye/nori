class Nori
  module Nodes
    class Base64Node < ValueNode
      def render
        @value.unpack('m').first
      end
    end
  end
end
