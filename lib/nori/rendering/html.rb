class Nori
  module Rendering
    class HTML
      def initialize(node, config)
        @node = node
        @config = config
      end

      def render
        inner_html = @node.nested_nodes.join

        { @node.name => ValueNodeFactory.build(inner_html, @node.attributes, @config).render }
      end
    end
  end
end
