require 'erb'

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
        if @layout_data
          render_in_layout { @data }
        else
          ERB.new(@data).result
        end
      end
    end

    private

    def render_in_layout
      ERB.new(@layout_data).result(binding)
    end
  end
end
