require "erb"
require "tilt"

module Hyperloop
  class View
    def initialize(view_registry, full_path, layout_path=nil)
      @view_registry = view_registry
      @full_path     = full_path
      @data          = File.read(@full_path)

      # Only load layout data if all of these things are true:
      #
      # 1. We're not in a partial
      # 2. A layout path was provided
      # 3. There's a file at the provided layout path
      if !partial? && layout_path && File.file?(layout_path)
        @layout_data = File.read(layout_path)
      end
    end

    # Public: The format of the view. Derived from the view's extension.
    #
    # Returns a string.
    def format
      @format ||= File.extname(@full_path)[1..-1].intern
    end

    # Public: The name of the view. Derived from the view's filename without
    # any extensions or leading underscores. Not guaranteed to be unique amongst
    # other views in an app.
    #
    # Returns a string.
    def name
      @name ||= filename.split(".").first.sub(/^_/, '')
    end

    # Public: Is this view a partial?
    #
    # Returns a boolean.
    def partial?
      @partial ||= filename.start_with?('_')
    end

    # Public: Render the view.
    #
    # request - Rack request object that the view is being rendered in response
    #           to.
    #
    # Returns a string.
    def render(request)
      case format
      when :html
        @data
      when :erb
        scope     = Scope.new(request, @view_registry)
        view_html = Tilt["erb"].new { @data }.render(scope)

        if @layout_data
          layout_template = Tilt["erb"].new { @layout_data }
          layout_template.render(scope) { view_html }
        else
          view_html
        end
      end
    end

    private

    def filename
      filename ||= File.basename(@full_path)
    end
  end
end
