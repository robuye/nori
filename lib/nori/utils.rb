class Nori
  module Utils
    extend self

    def render_attributes(attributes, config)
      hash = attributes.inject({}) do |memo, (k,v)|
        memo[convert_attribute_name("@#{k}", config.convert_tags_to)] = v
        memo
      end

      hash.empty? ? nil : hash
    end

    def undasherize_hash
      lambda do |hash|
        hash.inject({}) do |memo, (k,v)|
          memo[undasherize.call(k)] = v
          memo
        end
      end
    end

    def undasherize
      lambda {|name| name.tr('-', '_') }
    end

    def snakecase(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr(".", "_").
        tr("-", "_").
        downcase
    end

    def group_by_key(collection)
      collection.inject do |memo, element|
        memo.merge(element) {|_, o, n| [o, n]}
      end
    end

    def delete_namespace_attributes
      lambda do |attributes|
        attributes.delete_if {|k,v| k[/\A(xmlns|xsi)/]}
      end
    end

    def strip_namespaces
      lambda {|input| input.split(':').last }
    end

    # make namespaces easier available
    def filter_namespaces(attributes)
      regex = /\A(.*:)?(.*)\Z/

      attributes.map do |(k,v)|
        match = regex.match(k)
        {
          name: match[2], 
          namespace: match[1], 
          value: v
        }
      end
    end

    def to_xml_attributes(hash)
      hash.map do |k, v|
        %{#{Utils.snakecase(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}="#{v}"}
      end.join(' ')
    end

    private

    def convert_attribute_name(attribute, convert_proc=nil)
      return attribute unless convert_proc
      convert_proc.call(attribute)
    end

    def to_params(hash)
      hash.map {|k, v| normalize_param(k,v) }.join.chop
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
