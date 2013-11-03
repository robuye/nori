class Nori
  module Renderable
    def render_attributes
      Utils.render_attributes(attributes, config)
    end

    def to_s
      attr = to_xml_attributes(attributes)

      #join only if attributes are not empty, otherwise it would
      #insert :space: before closing bracket
      string = "<#{attr.any? ? [name, attr].join(' ') : name}>"
      nested_nodes.each {|n| string << n.to_s }
      string << "</#{name}>"
    end

    def render
      engine.render
    end

    alias_method :to_hash, :render

    private

    def to_xml_attributes(hash)
      hash.map do |k, v|
        %{#{Utils.snakecase(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}="#{v}"}
      end
    end

    def normalize_param(key, value)
      param = ''
      stack = []

      if value.is_a?(Array)
        param << value.map { |element| normalize_param("#{key}[]", element) }.join
      elsif value.is_a?(Hash)
        stack << [key,value]
      else
        param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
      end

      stack.each do |parent, hash|
        hash.each do |key, value|
          if value.is_a?(Hash)
            stack << ["#{parent}[#{key}]", value]
          else
            param << normalize_param("#{parent}[#{key}]", value)
          end
        end
      end

      param
    end
  end
end
