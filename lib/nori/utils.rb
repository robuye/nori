class Nori
  module Utils
    extend self

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

    private

    def to_params(hash)
      hash.map {|k, v| normalize_param(k,v) }.join.chop
    end
  end
end
