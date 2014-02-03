class Nori
  module Renderable
    def render_attributes
      attributes.render
    end

    #returns string XML/HTML representation of node
    #including all children nodes with attributes
    def to_s
      string = "<#{[name, attributes.to_s].join(' ').strip}>"
      nested_nodes.each {|n| string << n.to_s }
      string << "</#{name}>"
    end

    def render
      engine.render
    end

    alias_method :to_hash, :render
  end
end
