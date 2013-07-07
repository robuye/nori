class Nori
  module Utils
    extend self

    def render_attributes(attributes, options={})
      hash = attributes.inject({}) do |memo, (k,v)|
        memo[Utils.convert_attribute_name("@#{k}", options[:convert_tags_to])] = v
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

    def convert_attribute_name(attribute, convert_proc=nil)
      return attribute unless convert_proc
      convert_proc.call(attribute)
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
  end
end
