require "delegate"
require "date"
require "time"
require "bigdecimal"
require 'stringio'

require "nori/renderable"
require "nori/nodes"
require "nori/value_node_factory"
require "nori/rendering"
require "nori/utils"
require "nori/xml_utility_node"
require "nori/middleware"
require "nori/config"

require "nori/version"

class Nori
  attr_reader :config

  PARSERS = { :rexml => "REXML", :nokogiri => "Nokogiri" }

  def initialize(options = {})
    @config = Config.new(options)
    yield @config if block_given?
  end

  def find(hash, *path)
    return hash if path.empty?

    key = Middleware.new(config).process_tag(path.shift)

    return nil unless hash.include? key
    find(hash[key], *path)
  end

  def parse(xml)
    cleaned_xml = xml.strip
    return {} if cleaned_xml.empty?

    parser = load_parser(config.parser)
    parser.parse(cleaned_xml, config)
  end

  private

  def load_parser(parser)
    require "nori/parser/#{parser}"
    Parser.const_get PARSERS[parser]
  end
end
