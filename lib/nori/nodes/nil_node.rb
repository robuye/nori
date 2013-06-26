class Nori
  module Nodes
    class NilNode < DelegateClass(NilClass)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(nil)
      end

      def nil?
        true
      end

      #this is current behavior described by specs, its not really a nil node
      #if we render attributes #FIXME
      def render
        attributes.empty? ? self : Utils.render_attributes(attributes)
      end
    end
  end
end
