class Nori
  module Nodes
    class FileNode < DelegateClass(StringIO)
      attr_reader :value, :attributes

      def initialize(value, attributes, opts={})
        @value = value
        @attributes = attributes
        @options = opts
        super(StringIO.new(value.unpack('m').first))
      end

      def render
        self
      end

      def original_filename
        @attributes['name'] || 'untitled'
      end

      def content_type
        @attributes['content_type'] || 'application/octet-stream'
      end
    end
  end
end
