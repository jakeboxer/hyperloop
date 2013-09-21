require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    attr_reader :views

    def initialize(root='')
      @root       = root
      @views_path = File.join(@root, 'app/views')
      @views      = Dir.entries(@views_path) - %w(. ..)
    end

    # Rack call interface.
    def call(env)
      @env      = env
      @request  = Rack::Request.new(@env)
      @response = Response.new

      filename = @request.path.gsub(/^\//, '')
      filename = 'index' if filename.empty?
      filename += '.html'

      if views.include?(filename)
        @response.write(File.read(File.join(@views_path, filename)))
      end

      @response.finish
    end
  end
end
