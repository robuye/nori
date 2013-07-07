require "rexml/parsers/baseparser"
require "rexml/text"
require "rexml/document"

class Nori
  module Parser

    # = Nori::Parser::REXML
    #
    # REXML pull parser.
    module REXML

      def self.parse(xml, config)
        stack = []
        parser = ::REXML::Parsers::BaseParser.new(xml)
        middleware = config.middleware

        while true
          event = unnormalize(parser.pull)
          case event[0]
          when :end_document
            break
          when :end_doctype, :start_doctype
            # do nothing
          when :start_element
            tag = middleware.process_tag(event[1])
            attributes = middleware.process_attributes(event[2])

            stack.push XmlUtilityNode.new(tag, attributes, config)
          when :end_element
            if stack.size > 1
              last = stack.pop
              stack.last.add_child(last)
            end
          when :text, :cdata
            stack.last.add_text(event[1]) unless stack.empty? #REXML would consider new line character before the XML starts as an element
          end
        end
        stack.length > 0 ? stack.pop.to_hash : {}
      end

      private

      def self.unnormalize(event)
        event.map! do |el|
          if el.is_a?(String)
            ::REXML::Text.unnormalize(el)
          elsif el.is_a?(Hash)
            el.each {|k,v| el[k] = ::REXML::Text.unnormalize(v)}
          else
            el
          end
        end
      end
    end
  end
end
