class Nori
  class XmlUtilityNode
    attr_reader :name, :attributes, :nested_nodes, :config

    def initialize(name, attributes = {}, config)
      @config = config
      @name = name
      @attributes = Attributes.new(attributes, config)

      @nested_nodes = []

      @composite_num = 0
      @text_num  = 0
    end

    # Puts composite node to inside current node. Used internally.
    def add_child(node)
      @composite_num += 1
      nested_nodes << node
    end

    # Convert text inside tag to value node and add to nested nodes. Used
    # internally.
    def add_text(text)
      if text.strip.length > 0
        add_child( ValueNodeFactory.build(text, attributes, config) )

        @text_num += 1
        @composite_num -= 1
      end
    end

    # Returns string XML/HTML representation of node including all children
    # nodes with attributes. It's very likely that the output will be different
    # from original document.
    def to_s
      string = "<#{[name, attributes.to_s].join(' ').strip}>"
      nested_nodes.each {|n| string << n.to_s }
      string << "</#{name}>"
    end

    def render
      engine.render
    end
    alias_method :to_hash, :render

    private

    # Engine used to convert node into hash. If node is built of text and
    # other nodes (i.e. <root>hello<b>world</b></root>) it will choose HTML
    # engine, resulting in rendering content as string (i.e. { :root =>
    # "hello<b>world</b>" } ). This is a feature, not a bug. Can be overriden,
    # but the results may be unexpected.
    def engine
      # Nokogiri parsing tag with escaped special characters splits the input
      # i.e. "one&amp;two" will be parsed as 3 objects [one, &, two]
      # according to documentation its not necesarry a bug:
      #  Nokogiri::XML::SAX::Document.characters(string)
      #  "Characters read between a tag. This method might be called multiple
      #   times given one contiguous string of characters."
      # 
      # REXML parses this as one object, it may yield different results

      if (@text_num > 0 && @composite_num > 0) || (@text_num > 1)
        Rendering::HTML.new(self, config)
      elsif (attributes.raw['type'] == 'array')
        Rendering::Array.new(self, config)
      else
        Rendering::XML.new(self, config)
      end
    end
  end
end
