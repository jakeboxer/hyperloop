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
      request  = Rack::Request.new(env)
      response = Response.new

      path = File.join(@views_path, request.path).chomp('/')

      # If we're currently pointing to a directory, get index in it.
      path = File.join(path, 'index') if Dir.exist?(path)
      path += '.html'

      if File.exist?(path)
        response.write(File.read(path))
      else
        response.status = 404
      end

      response.finish
    end
  end
end
