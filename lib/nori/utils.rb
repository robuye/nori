class Nori
  module Utils
    extend self

    def undasherize_keys(hash)
      result = {}
      hash.keys.each {|key| result[key.tr('-', '_')] = hash[key]}
      result
    end

    def convert_attribute_name(attribute)
        return attribute unless @options[:convert_tags_to].respond_to?(:call)
        @options[:convert_tags_to].call(attribute)
    end

    def group_by_key(collection)
        collection.inject do |memo, element|
          memo.merge(element) {|_, o, n| [o, n].flatten}
        end
    end

    def remove_namespace_attributes!(attributes)
      attributes.keys.each do |key|
        attributes.delete(key) if key[/\A(xmlns|xsi)/]
      end
    end

    def convert_attribute_name(attribute, convert_proc=nil)
      return attribute unless convert_proc
      convert_proc.call(attribute)
    end
  end
end
