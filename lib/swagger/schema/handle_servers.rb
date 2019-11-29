require_relative "./util"
require_relative "./server"

module Swagger
  class Schema
    module HandleServers
      def servers
        Util.try_hash(@schema, :servers)
      end

      def server(index)
        Server.new(servers[index])
      end

      def server_by_description(description)
        Server.new(servers.find { |server| server.description == description })
      end
    end
  end
end
