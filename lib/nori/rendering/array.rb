class Nori
  module Rendering
    class Array
      def initialize(node, config=nil)
        @node = node
      end

      def render
        @node.attributes.delete('type')

        {
          @node.name => @node.nested_nodes.map do |nested|
                         nested.render[nested.name]
                       end
        }
      end
    end
  end
end
