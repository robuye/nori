require 'facets/hash/update_keys'

class Nori
  class Middleware
    module Tags
      class Undasherize
        def initialize(app)
          @app = app
        end

        def call(env)
          undasherize(env)

          @app.call(env)
        end

        private

        def undasherize(string)
          string.tr!('-', '_')
        end
      end

      class StripNamespace
        def initialize(app)
          @app = app
        end

        def call(env)
          strip_namespace!(env)
          @app.call(env)
        end

        private

        def strip_namespace!(input)
          input.slice!(/.*:/)
        end
      end
    end
  end
end
