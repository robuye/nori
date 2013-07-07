require "nokogiri"

class Nori
  module Parser

    # = Nori::Parser::Nokogiri
    #
    # Nokogiri SAX parser.
    module Nokogiri
      class Document < ::Nokogiri::XML::SAX::Document
        attr_accessor :config

        def stack
          @stack ||= []
        end

        def middleware
          config.middleware
        end

        def start_element(name, attrs = [])
          tag = middleware.process_tag(name)
          attributes = middleware.process_attributes(Hash[*attrs.flatten])

          stack.push XmlUtilityNode.new(tag, attributes, config)
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

      def self.parse(xml, config)
        document = Document.new
        document.config = config
        parser = ::Nokogiri::XML::SAX::Parser.new document
        parser.parse xml
        document.stack.length > 0 ? document.stack.pop.to_hash : {}
      end
    end
  end
end
