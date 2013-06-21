class Nori
  module Nodes
    class ValueNodeFactory
      TYPECASTS = {
        'base64Binary' => Base64Node,
        'boolean'      => BooleanNode,
        'date'         => DateNode,
        'datetime'     => DateTimeNode,
        'decimal'      => DecimalNode,
        'double'       => DoubleNode,
        'file'         => FileNode,
        'float'        => FloatNode,
        'integer'      => IntegerNode,
        'string'       => StringNode,
        'time'         => TimeNode
      }

      XS_DATE = /\A[-]?\d{4}-\d{2}-\d{2}[Z\-\+]?\d*:?\d*\Z/
      XS_TIME = /\A\d{2}:\d{2}:\d{2}[Z\.\-\+]?\d*:?\d*\Z/
      XS_DATE_TIME = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\.Z]?\d*[\-\+]?\d*:?\d*\Z/
      XS_BOOLEAN = /\A(true|false)\Z/


      def self.build(value, attrs, opts = {})
        type = TYPECASTS[attrs['type']] ?
          attrs.delete('type') : attrs['type']

        if opts[:advanced_typecasting]
          (TYPECASTS[type] || guess_type(value)).new(value, attrs, opts)
        else
          (TYPECASTS[type] || TextNode).new(value, attrs, opts)
        end
      rescue
        TextNode.new(value, attrs, opts)
      end

      def self.guess_type(value)
        case
        when value =~ XS_DATE      then DateNode
        when value =~ XS_DATE_TIME then DateTimeNode
        when value =~ XS_TIME      then TimeNode
        when value =~ XS_BOOLEAN   then BooleanNode
        else TextNode
        end
      end
    end
  end
end
