class Nori
  module Rendering
    class XML
      def initialize(node, config)
        @node = node
        @config = config
      end

      def render
        @grouped_children = [Utils.group_by_key(@node.nested_nodes.map(&:render))].compact

        if @grouped_children.empty?
          render_empty
        elsif @grouped_children.length == 1
          render_single
        else
          render_collection
        end
      end

      private

      def render_empty
        nil_att = Utils.filter_namespaces(@node.attributes.raw).find{|h| h[:name] == "nil" && h[:value] == 'true'}

        #this is special case when node has NIL type. Source:
        #See: http://stackoverflow.com/questions/7238254/xml-what-is-this-null-or-empty-element
        #we loose attributes here, this behavior is described in specs, possibly a bug #FIXME
        if nil_att
          @node.attributes.raw.delete("#{nil_att[:namespace]}#{nil_att[:name]}")
          nil_node = Nodes::NilNode.new(nil, {})
          nil_node.config = @config
          { @node.name => nil_node.render }

        #this is special case when node has no content but has type specified
        #we try to cast empty value into this type
        elsif @node.attributes.raw['type']
          { @node.name => ValueNodeFactory.build('', @node.attributes, @config).render }
        else
          { @node.name => @node.attributes.render }
        end
      end

      def render_single
        #we have 1 composite node here. composite nodes represented with hashes
        #do not expose #attributes method, so we merge them.
        if @grouped_children.first.is_a? Hash
          { @node.name => @grouped_children.first.merge((@node.attributes.render || {})) }
        else #whatever is inside it can handle the attributes on its own
          { @node.name => @grouped_children.first }
        end
      end

      def render_collection
        { @node.name => @grouped_children }.merge(@node.attributes.render || {})
      end
    end
  end
end
