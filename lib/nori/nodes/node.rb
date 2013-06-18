class Nori
  module Nodes
    class Node
      attr_reader :name, :attributes, :nested_nodes, :value, :options

      def initialize(name, attributes = {}, options = {})
        @options = options
        @name = Nori.hash_key(name, options) #DRY it (see #undesherize_attributes)
        @nested_nodes = []
        @attributes = Utils.undasherize_keys(attributes)
        @value = ''

        Utils.remove_namespace_attributes!(@attributes) if @options[:delete_namespace_attributes]
      end

      def add_child(node)
        nested_nodes << node
      end

      def add_text(text)
        value << text
      end

      def to_hash
        { @name => render }
      end

      private

      def render
        nodes = [Utils.group_by_key(nested_nodes.flat_map(&:to_hash))].compact
        val = render_value

        if nodes.empty? && !val.nil?   #no child nodes, just value
          val                #make attributes accessible via val (issue #5)
        elsif nodes.empty? && val.nil? #no child nodes, no value
          render_attributes  #refactor it, inconsistent access to attributes? (issue #5)
        elsif nodes.any? && !val.nil?  #has child nodes and value, join them
          nodes << val
        elsif nodes.length == 1        #just 1 element, dont need an array
          nodes.first.merge(render_attributes || {} )
        else                           #multiple elements and no text value
          nodes
        end
      end

      def render_attributes
        hash = attributes.inject({}) do |memo, (k,v)|
          memo[Utils.convert_attribute_name("@#{k}", options[:convert_tags_to])] = v
          memo
        end

        hash.empty? ? nil : hash
      end

      def render_value
        ValueNodeFactory.build(value, attributes, options).render
      rescue #would be good idea to handle it somehow better
        TextNode.new(value, attributes, options).render
      end
    end
  end
end
