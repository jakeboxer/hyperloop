module Hyperloop
  class View
    class Scope
      attr_reader :request

      def initialize(request)
        @request = request
      end
    end
  end
end
