class Nori
  class ValueNodeFactory
    TYPECASTS = {
      'base64Binary' => Nodes::Base64Node,
      'boolean'      => Nodes::BooleanNode,
      'date'         => Nodes::DateNode,
      'datetime'     => Nodes::DateTimeNode,
      'decimal'      => Nodes::DecimalNode,
      'double'       => Nodes::DoubleNode,
      'file'         => Nodes::FileNode,
      'float'        => Nodes::FloatNode,
      'integer'      => Nodes::IntegerNode,
      'string'       => Nodes::StringNode,
      'time'         => Nodes::TimeNode
    }

    XS_DATE = /\A[-]?\d{4}-\d{2}-\d{2}[Z\-\+]?\d*:?\d*\Z/
    XS_TIME = /\A\d{2}:\d{2}:\d{2}[Z\.\-\+]?\d*:?\d*\Z/
    XS_DATE_TIME = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\.Z]?\d*[\-\+]?\d*:?\d*\Z/
    XS_BOOLEAN = /\A(true|false)\Z/


    def self.build(value, attrs, config)
      type = TYPECASTS[attrs.raw['type']] ?
        attrs.raw.delete('type') : attrs.raw['type']

      if config.advanced_typecasting
        (TYPECASTS[type] || guess_type(value)).new(value, attrs.raw)
      else
        (TYPECASTS[type] || Nodes::TextNode).new(value, attrs.raw)
      end
    rescue
      Nodes::TextNode.new(value, attrs.raw)
    end

    def self.guess_type(value)
      case
      when value =~ XS_DATE      then Nodes::DateNode
      when value =~ XS_DATE_TIME then Nodes::DateTimeNode
      when value =~ XS_TIME      then Nodes::TimeNode
      when value =~ XS_BOOLEAN   then Nodes::BooleanNode
      else Nodes::TextNode
      end
    end
  end
end
