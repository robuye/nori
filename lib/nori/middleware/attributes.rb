class Nori
  class Middleware
    module Attributes
      extend self

      def undasherize
        lambda do |hash|
          hash.inject({}) do |memo, (k,v)|
            memo[Utils.undasherize(k)] = v
            memo
          end
        end
      end

      def delete_namespace_attributes
        lambda {|attr| attr.delete_if {|k,v| k[/\A(xmlns|xsi)/]}}
      end
    end
  end
end
