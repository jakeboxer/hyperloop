module Hyperloop
  class View
    def initialize(full_path)
      @full_path = full_path
      @data      = File.read(@full_path)
    end

    def render
      @data
    end
  end
end
