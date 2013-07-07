class Nori
  module Nodes
    class NilNode < DelegateClass(NilClass)
      attr_reader :value, :attributes
      #This is hack for backward compatibility, I need access to config
      #in order to "prefix" attributes for this special case.
      #Possibly a bug (see comment below) #FIXME
      attr_accessor :config

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(nil)
      end

      def nil?
        true
      end

      #this is current behavior described by specs, its not really a nil node
      #if we render attributes #FIXME
      def render
        attributes.empty? ? self : Utils.render_attributes(attributes, config)
      end

      private

      def config
        @config || Config.new
      end
    end
  end
end
