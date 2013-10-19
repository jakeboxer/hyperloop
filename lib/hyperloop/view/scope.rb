require 'tilt'

module Hyperloop
  class View
    class Scope
      attr_reader :request

      def initialize(request, view_registry)
        @request       = request
        @view_registry = view_registry
      end

      # Public: Render the specified partial.
      #
      # path - Path to look for the partial at.
      #
      # Returns a string.
      def render(path)
        @view_registry.find_partial_view(path).render(request)
      end
    end
  end
end
