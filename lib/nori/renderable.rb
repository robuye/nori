class Nori
  module Renderable
    #copy of Utils (used in NilNode aswell), FIXME
    def render_attributes
      hash = attributes.inject({}) do |memo, (k,v)|
        memo[Utils.convert_attribute_name("@#{k}", config.convert_tags_to)] = v
        memo
      end

      hash.empty? ? nil : hash
    end
    
    def to_s
      string = "<#{name}#{attributes.to_xml_attributes}>"
      nested_nodes.each do |n|
        string << n.to_s
      end
      string << "</#{name}>"
    end

    def render
      engine.render
    end

    alias_method :to_hash, :render
  end
end
