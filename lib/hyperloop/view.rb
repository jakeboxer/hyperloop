require 'erb'

module Hyperloop
  class View
    def initialize(full_path)
      @full_path = full_path
      @data      = File.read(@full_path)
      @format    = File.extname(@full_path)[1..-1]
    end

    def render
      case @format
      when 'html'
        @data
      when 'erb'
        ERB.new(@data).result
      end
    end
  end
end
