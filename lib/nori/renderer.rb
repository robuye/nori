class Nori
  module RenderEngine
    module XML
      extend self

      def render(node)
        @nodes = [Utils.group_by_key(node.nested_nodes.map(&:render))].compact

        if @nodes.empty?
          render_empty(node)
        elsif @nodes.length == 1
          render_single(node)
        else
          render_collection(node)
        end

      ensure
        @nodes = nil #bad code bad, make me threadsafe #FIXME
      end

      private

      def render_empty(node)
        #this is special case when node has NIL type. Source:
        #See: http://stackoverflow.com/questions/7238254/xml-what-is-this-null-or-empty-element
        nil_att = Utils.filter_namespaces(node.attributes).find{|h| h[:name] == "nil" && h[:value] == 'true'}
        if nil_att
          node.attributes.delete("#{nil_att[:namespace]}#{nil_att[:name]}")
          { node.name => Nodes::NilNode.new(nil, {}, node.options).render }
        #this is special case when node has no content but has type specified
        #we try to cast empty value into this type
        elsif node.attributes['type']
          { node.name => ValueNodeFactory.build('', node.attributes, node.options).render }
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

        { node.name => ValueNodeFactory.build(inner_html, node.attributes, node.options).render }
      end
    end

    module Array
      extend self

      def render(node)
        node.attributes.delete('type')
        {
          node.name => node.nested_nodes.map do |nested|
                         nested.render[nested.name]
                       end
        }
      end
    end
  end
end
