class Nori
  module Rendering
    class HTML
      def initialize(node)
        @node = node
      end

      def render
        inner_html = @node.nested_nodes.join

        { @node.name => ValueNodeFactory.build(inner_html, @node.attributes, @node.options).render }
      end
    end
  end
end
