require 'facets/date'

class Nori
  module Nodes
    class DateTimeNode < DelegateClass(DateTime)
      attr_reader :value, :attributes

      def initialize(value, attributes)
        @value = value
        @attributes = attributes
        super(parse_time(value))
      end

      def render
        self
      end

      #default #to_s would loose miliseconds on transform so...
      def to_s
        self.iso8601(9)
      end

      private

      def parse_time(input)
        if (input =~ /(((\+|\-)\d\d(:)?(\d\d)?)|Z)\Z/)
          DateTime.parse(input)
        else
          DateTime.parse(input.to_time(:local).to_s)
        end
      end
    end
  end
end
