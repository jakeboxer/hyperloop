require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root=nil)
      @root       = root
      @views_path = File.join([@root, 'app/views'].compact)
    end

    # Rack call interface.
    def call(env)
      request  = Rack::Request.new(env)
      response = Response.new
      path     = view_path(request)

      if File.exist?(path)
        # If there's a file at the view path, use its data as the response body.
        data = File.read(path)
        response.write(data)
      else
        # If there's no file at the view path, 404.
        response.status = 404
      end

      response.finish
    end

    private

    # Internal: Get the view path for the specified request.
    #
    # request - Rack::Request to get the view path for.
    #
    # Returns a String.
    def view_path(request)
      path = File.join(@views_path, request.path).chomp('/')

      # If we're currently pointing to a directory, get index in it.
      path = File.join(path, 'index') if Dir.exist?(path)
      path + '.html'
    end
  end
end
