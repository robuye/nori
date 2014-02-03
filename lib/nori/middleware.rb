require "nori/middleware/attributes"
require "nori/middleware/tags"

class Nori
  class Middleware
    attr_accessor :tags, :attributes

    def initialize(config)
      @config = config
    end

    def tags(&block)
      if block_given?
        @tags = block.call
      else
        @tags = ::Middleware::Builder.new
        legacy_config_tags_middleware.each {|m| @tags.use m}
      end
      @tags
    end

    def attributes(&block)
      if block_given?
        @attributes = block.call
      else
        @attributes = ::Middleware::Builder.new
        legacy_config_attributes_middleware.each {|m| @attributes.use(m)}
      end
      @attributes
    end

    private

    def legacy_config_attributes_middleware
      defaults = []
      defaults << Attributes::RemoveNamespace if config.delete_namespace_attributes
      defaults << Attributes::Undasherize
      defaults
    end

    def legacy_config_tags_middleware
      defaults = [  ]
      defaults << Tags::StripNamespace if config.strip_namespaces
      defaults << Tags::Undasherize
      defaults << config.convert_tags_to if config.convert_tags_to
      defaults
    end

    def config
      @config
    end

    class Snakecase
      def initialize(app)
        @app = app
      end

      def call(env)
        snakecase!(env)

        @app.call(env)
      end

      private

      def snakecase!(string)
        string.gsub!(/::/, '/')
        string.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        string.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        string.tr!(".", "_")
        string.tr!("-", "_")
        string.downcase!
      end
    end
  end
end
