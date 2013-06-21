class Nori
  module RenderEngine
    module XML
      extend self
      def render(node)
        nodes = [Utils.group_by_key(node.nested_nodes.flat_map(&:render))].compact

        #this is required to keep attributes handling as it is.
        if nodes.empty? && node.attributes.empty?
          { node.name => Nodes::NilNode.new(nil, {}) }
        elsif nodes.empty?
          #this is special case when node has no content but has type specified
          #we try to cast empty value into this type
          if node.attributes['type']
            { node.name => Nodes::ValueNodeFactory.build('', node.attributes, node.options) }
          else
            { node.name => node.render_attributes }
          end
        elsif nodes.length == 1
          #we have 1 composite node here. composite nodes represtned with hashes
          #do not expose #attributes method, so we merge them.
          if nodes.first.is_a? Hash
            { node.name => nodes.first.merge((node.render_attributes || {})) }
          else #whatever was inside it can handle the attributes on its own
            { node.name => nodes.first }
          end
        #a collection here, no way to bind the attributes, so we merge them
        else
          { node.name => nodes }.merge(node.render_attributes || {})
        end
      end
    end

    module HTML
      extend self

      def render(node)
        inner_html = node.nested_nodes.join

        #this causes double rendering and many troubles ;(
        result = begin
                   Nodes::ValueNodeFactory.build(inner_html, node.attributes, node.options).render
                 rescue
                   Nodes::TextNode.new(inner_html, node.attributes, node.options).render
                 end
        { node.name => result }
      end
    end
  end
end
