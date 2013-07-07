class Nori
  class Middleware
    attr_accessor :tag_steps, :attribute_steps
    def initialize(opts={})
      @options = opts
      @tag_steps = []
      @attribute_steps = []

      load_default_steps
    end

    def process_tag(tag)
      tag_steps.inject(tag) {|memo, step| step.call(memo)}
    end

    def process_attributes(attrs)
      attribute_steps.inject(attrs) {|memo, stap| stap.call(memo)}
    end

    private

    def load_default_steps
      tag_steps << Utils.undasherize
      tag_steps << @options[:convert_tags_to] if @options[:convert_tags_to]
      tag_steps << Utils.strip_namespaces if @options[:strip_namespaces]

      attribute_steps << Utils.delete_namespace_attributes if @options[:delete_namespace_attributes]
      attribute_steps << Utils.undasherize_hash
    end
  end
end
