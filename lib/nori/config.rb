class Nori
  class Config
    attr_accessor :strip_namespaces, :delete_namespace_attributes,
                  :convert_tags_to, :advanced_typecasting, :parser

    def initialize(options={})
      validate_options!(options)
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def middleware
      @middleware ||= Middleware.new(self)
    end

    def advanced_typecasting
      @advanced_typecasting.nil? ? true : @advanced_typecasting
    end

    def parser
      @parser || :nokogiri
    end

    private

    def validate_options!(options)
      spurious_options = options.keys - available_options
      if spurious_options.any?
        raise ArgumentError, "Spurious options: #{spurious_options}. Avaliable options are #{available_options}"
      end
    end

    def available_options
      self.public_methods(false).reject{|m| m[-1] == '='}
    end
  end
end
