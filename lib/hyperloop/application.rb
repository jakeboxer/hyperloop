require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root=nil)
      @root       = root
      @views_root = File.join([@root, 'app/views'].compact)

      # Load all the views
      paths  = Dir.glob(@views_root + '/**/*').reject {|fn| File.directory?(fn)}
      @views = paths.inject({}) do |result, path|
        result[path] = View.new(path)
        result
      end
    end

    # Rack call interface.
    def call(env)
      request  = Rack::Request.new(env)
      response = Response.new
      path     = view_path(request)

      if view = @views[path]
        # If there's a view at the path, use its data as the response body.
        data = view.render
        response.write(data)
      else
        # If there's no view at the path, 404.
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
      path = File.join(@views_root, request.path).chomp('/')

      # If we're currently pointing to a directory, get index in it.
      path = File.join(path, 'index') if Dir.exist?(path)
      path + '.html'
    end
  end
end
