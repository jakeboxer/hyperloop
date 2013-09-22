require 'erb'

module Hyperloop
  class View
    def initialize(full_path)
      @full_path = full_path
      @data      = File.read(@full_path)
      @format    = File.extname(@full_path)[1..-1]
    end

    # Public: Render the view.
    #
    # Returns a string.
    def render
      case @format
      when 'html'
        @data
      when 'erb'
        ERB.new(@data).result
      end
    end

    # Public: The name of the view. Derived from the view's filename without
    # any extensions. Not guaranteed to be unique amongst other views in an app.
    #
    # Returns a string.
    def name
      @name ||= File.basename(@full_path).split('.').first
    end
  end
end
