class Nori
  module RenderEngine
    module XML
      extend self

      def render(node)
        @nodes = [Utils.group_by_key(node.nested_nodes.flat_map(&:render))].compact

        if @nodes.empty?
          render_empty(node)
        elsif @nodes.length == 1
          render_single(node)
        else
          render_collection(node)
        end

      ensure
        @nodes = nil
      end

      private

      def render_empty(node)
        #this is special case when node has no content but has type specified
        #we try to cast empty value into this type
        #but what if we fail? ;( #FIXME
        if node.attributes['type']
          { node.name => Nodes::ValueNodeFactory.build('', node.attributes, node.options) }
        else
          { node.name => node.render_attributes }
        end
      end

      def render_single(node)
        #we have 1 composite node here. composite nodes represented with hashes
        #do not expose #attributes method, so we merge them.
        if @nodes.first.is_a? Hash
          { node.name => @nodes.first.merge((node.render_attributes || {})) }
        else #whatever is inside it can handle the attributes on its own
          { node.name => @nodes.first }
        end
      end

      def render_collection(node)
        { node.name => @nodes }.merge(node.render_attributes || {})
      end
    end

    module HTML
      extend self

      def render(node)
        inner_html = node.nested_nodes.join
        result = begin #This is used in too many places, #DRY ME
                   Nodes::ValueNodeFactory.build(inner_html, node.attributes, node.options).render
                 rescue
                   Nodes::TextNode.new(inner_html, node.attributes, node.options).render
                 end

        { node.name => result }
      end
    end
  end
end
