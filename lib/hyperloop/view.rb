require 'erb'
require 'tilt'

module Hyperloop
  class View
    def initialize(full_path, layout_path=nil)
      @full_path   = full_path
      @data        = File.read(@full_path)
      @layout_data = File.read(layout_path) if layout_path && File.file?(layout_path)
    end

    # Public: The format of the view. Derived from the view's extension.
    #
    # Returns a string.
    def format
      @format ||= File.extname(@full_path)[1..-1].intern
    end

    # Public: The name of the view. Derived from the view's filename without
    # any extensions. Not guaranteed to be unique amongst other views in an app.
    #
    # Returns a string.
    def name
      @name ||= File.basename(@full_path).split('.').first
    end

    # Public: Render the view.
    #
    # Returns a string.
    def render
      case format
      when :html
        @data
      when :erb
        view_html = Tilt['erb'].new { @data }.render

        if @layout_data
          layout_template = Tilt['erb'].new { @layout_data }
          layout_template.render { view_html }
        else
          view_html
        end
      end
    end
  end
end
