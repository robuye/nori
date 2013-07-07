class Nori
  module Nodes
    # it produces False or True node, depending on input
    # Ruby does not have Boolean type representing both values
    # this is simple workaround.
    class BooleanNode 
      TRUE_REGEX = /\A(true)|1\Z/
      FALSE_REGEX = /\A(false)|0\Z/

      def self.new(value, attributes)
        klass(value.downcase.strip).new(value, attributes)
      end

      def self.klass(value)
        if value =~ FALSE_REGEX
          FalseNode
        elsif value =~ TRUE_REGEX
          TrueNode
        else
          raise "Invalid input for BooleanNode"  #fallback to TextNode
        end
      end
    end
  end
end
