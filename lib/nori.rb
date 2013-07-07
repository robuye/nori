require "delegate"
require "date"
require "time"
require "bigdecimal"
require 'stringio'

require "nori/core_ext"
require "nori/renderable"
require "nori/nodes"
require "nori/value_node_factory"
require "nori/rendering"
require "nori/utils"
require "nori/xml_utility_node"
require "nori/middleware"

require "nori/version"

class Nori
  PARSERS = { :rexml => "REXML", :nokogiri => "Nokogiri" }

  def initialize(options = {})
    defaults = {
      :strip_namespaces             => false,
      :delete_namespace_attributes  => false,
      :convert_tags_to              => nil,
      :advanced_typecasting         => true,
      :parser                       => :nokogiri
    }

    validate_options! defaults.keys, options.keys
    @options = defaults.merge(options)
  end

  def find(hash, *path)
    return hash if path.empty?

    key = Middleware.new(@options).process_tag(path.shift)

    return nil unless hash.include? key
    find(hash[key], *path)
  end

  def parse(xml)
    cleaned_xml = xml.strip
    return {} if cleaned_xml.empty?

    parser = load_parser @options[:parser]
    parser.parse(cleaned_xml, @options)
  end

  private

  def load_parser(parser)
    require "nori/parser/#{parser}"
    Parser.const_get PARSERS[parser]
  end

  def validate_options!(available_options, options)
    spurious_options = options - available_options

    unless spurious_options.empty?
      raise ArgumentError, "Spurious options: #{spurious_options.inspect}\n" \
                           "Available options are: #{available_options.inspect}"
    end
  end
end
