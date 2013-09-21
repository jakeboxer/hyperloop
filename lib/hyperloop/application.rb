require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root='')
      @root       = root
      @views_path = File.join(@root, 'app/views')
    end

    # Rack call interface.
    def call(env)
      @env      = env
      @request  = Rack::Request.new(@env)
      @response = Response.new

      file_name = @request.path.gsub(/^\//, '')
      file_name = 'index' if file_name.empty?
      file_name += '.html'
      file_path = File.join(@views_path, file_name)

      if File.exist?(file_path)
        @response.write(File.read(file_path))
      else
        @response.status = 404
      end

      @response.finish
    end
  end
end
