module Hyperloop
  class View
    class Scope
      attr_reader :request

      def initialize(request)
        @request = request
      end

      # Public: Render the specified partial.
      #
      # path - Path to look for the partial at.
      #
      # Returns a string.
      def render(path)
        path
      end
    end
  end
end
