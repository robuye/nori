require "nokogiri"

class Nori
  module Parser

    # = Nori::Parser::Nokogiri
    #
    # Nokogiri SAX parser.
    module Nokogiri
      class Document < ::Nokogiri::XML::SAX::Document
        attr_accessor :options

        def stack
          @stack ||= []
        end

        def start_element(name, attrs = [])
          stack.push Nodes::Node.new(name, Hash[*attrs.flatten], options)
        end

        def end_element(name)
          if stack.size > 1
            last = stack.pop
            stack.last.add_child(last)
          end
        end

        def characters(string)
          stack.last.add_text(string)
        end

        alias cdata_block characters

      end

      def self.parse(xml, options)
        document = Document.new
        document.options = options
        parser = ::Nokogiri::XML::SAX::Parser.new document
        parser.parse xml
        document.stack.length > 0 ? document.stack.pop.to_hash : {}
      end

    end
  end
end
