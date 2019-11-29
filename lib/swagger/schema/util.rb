module Swagger
  class Schema
    class Util
      class << self
        def try_hash(obj, name)
          if obj.respond_to?(:"[]")
            obj[name] || obj[name.is_a?(Symbol) ? name.to_s : name.to_sym]
          elsif obj.respond_to?(name)
            obj.send(name)
          end
        end

        def try_hash_with_integer(obj, name)
          if obj.respond_to?(:"[]")
            obj[name.to_i] || obj[name.to_s] || obj[name.to_s.to_sym]
          elsif obj.respond_to?(name)
            obj.send(name)
          end
        end
      end
    end
  end
end
