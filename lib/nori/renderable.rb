class Nori
  module Renderable
    def render_attributes
      Utils.render_attributes(attributes, config)
    end
    
    def to_s
      string = "<#{name}#{Utils.to_xml_attributes(attributes)}>"
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
