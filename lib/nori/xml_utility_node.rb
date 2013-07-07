class Nori
  class XmlUtilityNode
    include Nori::Renderable
    attr_reader :name, :attributes, :nested_nodes, :options

    def initialize(name, attributes = {}, options = {})
      @options = options
      @name = name
      @attributes = attributes

      @nested_nodes = []
      
      @composite_num = 0
      @text_num  = 0
    end

    def add_child(node)
      @composite_num += 1
      nested_nodes << node
    end

    # convert text inside tag to value node and add to nested nodes
    def add_text(text)
      if text.strip.length > 0
        add_child( ValueNodeFactory.build(text, attributes, options) )

        @text_num += 1
        @composite_num -= 1
      end
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
      #REXML parses this as one object, it may cause different results

      if (@text_num > 0 && @composite_num > 0) || (@text_num > 1)
        Rendering::HTML.new(self)
      elsif (attributes['type'] == 'array')
        Rendering::Array.new(self)
      else
        Rendering::XML.new(self)
      end
    end
  end
end
