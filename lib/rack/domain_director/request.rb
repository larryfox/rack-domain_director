module Rack
  class DomainDirector
    class Request < ::Rack::Request
      attr_writer :host

      def host
        @host || super
      end
    end
  end
end
