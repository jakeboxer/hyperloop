require 'tilt'

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
        # lol
        view_path = File.join("spec/fixtures/partials/app/views", File.dirname(path), "_" + File.basename(path)) + ".html.erb"
        data = File.read(view_path)
        Tilt["erb"].new { data }.render(self)
      end
    end
  end
end
