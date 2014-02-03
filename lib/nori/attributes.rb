class Nori
  class Attributes
    attr_reader :raw

    def initialize(raw, config)
      @raw = raw
      @config = config
    end

    def to_s
      raw.map {|k, v| %(#{Utils.snakecase(k.to_s)}="#{v}") }
    end

    def render
      hash = raw.inject({}) do |memo, (k,v)|
        memo[convert_attribute_name("@#{k}", @config.convert_tags_to)] = v
        memo
      end

      hash.empty? ? nil : hash
    end

    private

    def convert_attribute_name(attribute, convert_proc=nil)
      return attribute unless convert_proc
      convert_proc.call(attribute)
    end
  end
end
