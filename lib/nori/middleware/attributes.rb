require 'facets/hash/update_keys'

class Nori
  class Middleware
    module Attributes
      class Undasherize
        def initialize(app)
          @app = app
        end

        def call(env)
          undasherize(env)

          @app.call(env)
        end

        private

        def undasherize(hash)
          hash.update_keys {|k| k.tr('-', '_')}
        end
      end

      class RemoveNamespace
        DEFAULT_PATTERN = /\A(xmlns|xsi)/

        def initialize(app, pattern=nil)
          @app = app
          @pattern = pattern
        end

        def call(env)
          env.delete_if {|k,_| k[pattern]}

          @app.call(env)
        end

        private

        def pattern
          @pattern || DEFAULT_PATTERN
        end
      end
    end
  end
end
