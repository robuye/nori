class Nori
  module Nodes
    class Node
      attr_reader :name, :attributes, :nested_nodes, :value, :options

      def initialize(name, attributes = {}, options = {})
        @options = options
        @name = Nori.hash_key(name, options) #DRY it (see #undesherize_attributes)
        @nested_nodes = []
        @attributes = Utils.undasherize_keys(attributes)
        
        #keep track on number of nodes to choose whatever we should switch rendering engine
        @composite_num = 0
        @text_num  = 0

        Utils.remove_namespace_attributes!(@attributes) if @options[:delete_namespace_attributes]
      end

      def add_child(node)
        @composite_num = @composite_num + 1
        nested_nodes << node
      end

      # convert text inside tag to value node and add to nested nodes
      # mark this node as containing text value to render using different engine
      def add_text(text)
        if text.strip.length > 0
          add_child( ValueNodeFactory.build(text, attributes, options) )

          @text_num = @text_num + 1
          @composite_num = @composite_num - 1
        end
      end

      def render
        engine.render(self)
      end

      def render_attributes
        hash = attributes.inject({}) do |memo, (k,v)|
          memo[Utils.convert_attribute_name("@#{k}", options[:convert_tags_to])] = v
          memo
        end

        hash.empty? ? nil : hash
      end

      def to_hash
        render
      end

      def to_s
        string = "<#{name}#{attributes.to_xml_attributes}>"
        nested_nodes.each do |n|
          string << n.to_s
        end
        string << "</#{name}>"
      end

      private
      
      def engine
        #Nokogiri parsing tag with escaped special characters splits the input
        #i.e. "one&amp;two" will be parsed as 3 objects [one, &, two]
        #according to documentation its not necesarry a bug:
        # Nokogiri::XML::SAX::Document.characters(string)
        # "Characters read between a tag. This method might be called multiple
        #  times given one contiguous string of characters."
        #
        #REXML parses this as one object
        if (@text_num > 0 && @composite_num > 0) || (@text_num > 1)
          Nori::RenderEngine::HTML 
        else
          Nori::RenderEngine::XML
        end
      end
    end
  end
end
