class Nori
  module Nodes
    class FileNode < ValueNode
      def render
        file = StringIOFile.new((@value || '').unpack('m').first)
        file.original_filename = original_filename
        file.content_type = content_type
        file
      end

      private

      def original_filename
        @attributes['name'] || 'untitled'
      end

      def content_type
        @attributes['content_type'] || 'application/octet-stream'
      end
    end
  end
end
