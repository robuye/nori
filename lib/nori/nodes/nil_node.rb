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

      def render
        self
      end
    end
  end
end
