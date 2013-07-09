class Nori
  class Middleware
    module Tags
      extend self

      def undasherize
        lambda {|tag| Utils.undasherize(tag)}
      end

      def strip_namespaces
        lambda {|input| input.split(':').last }
      end
    end
  end
end
