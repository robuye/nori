class Nori
  module Nodes
    class Node
      attr_reader :name, :attributes, :nested_nodes, :value

      def initialize(name, attributes = {}, options = {})
        defaults = { advanced_typecasting: true }

        @options = defaults.merge(options)
        @name = Nori.hash_key(name, options) #DRY it (see #undesherize_attributes)
        @nested_nodes = []
        @attributes = undasherize_attributes(attributes)
        @value = ''

        remove_namespaces if @options[:delete_namespace_attributes]
      end

      def add_child(node)
          nested_nodes << node
      end

      def add_text(text)
        @value << text
      end

      def to_hash
        { @name => build }
      end

      private

      def build
        nodes = [group_by_key(nested_nodes.flat_map(&:to_hash))].compact
        val = render_value

        if nodes.empty? && !val.nil?   #make attributes accessible via val (issue #5)
          val
        elsif nodes.empty? && val.nil?
          prefixed_attributes_hash     #refactor it, but how? (issue #5)
        elsif nodes.any? && !val.nil?
          nodes + [val]
        elsif nodes.length == 1        #just 1 element, dont need an array
          nodes.first.merge(prefixed_attributes_hash || {} )
        else                           #multiple elements and no text value
          nodes
        end
      end

      def group_by_key(collection)
        collection.inject do |memo, element|
          memo.merge(element) {|_, o, n| [o, n].flatten}
        end
      end

      def prefixed_attributes_hash
        hash = attributes.inject({}) do |memo, (k,v)|
          memo[convert_attribute_name("@#{k}")] = v
          memo
        end

        hash.empty? ? nil : hash
      end

      def convert_attribute_name(attribute)
        return attribute unless @options[:convert_tags_to].respond_to?(:call)
        @options[:convert_tags_to].call(attribute)
      end

      def undasherize_attributes(attrs)
        result = {}
        attrs.keys.each do |key|
          result[key.tr("-", "_")] = attrs[key]
        end
        result
      end

      def render_value
        ValueNodeFactory.build(@value, attributes, @options).render
      rescue #would be good idea to handle it somehow better
        TextNode.new(@value, attributes, @options).render
      end
      
      def remove_namespaces
        @attributes.keys.each do |key|
          @attributes.delete(key) if key[/\A(xmlns|xsi)/]
        end
      end
    end
  end
end
