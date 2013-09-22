require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root=nil)
      @root       = root
      @views_root = File.join([@root, 'app/views'].compact)

      # Get all the view paths. These look like:
      #
      # some/path/app/views/whatever.html.erb
      # some/path/app/views/subdir/whatever.html.erb
      paths  = Dir.glob(@views_root + '/**/*').reject {|fn| File.directory?(fn)}

      @views = paths.inject({}) do |result, path|
        view = View.new(path)

        # The path under app/views. This will be something like:
        #
        # /whatever.html.erb
        # /subdir/whatever.html.erb
        relative_path = path.sub(@views_root, '')

        # The path under app/views without a file extension. This will be
        # something like:
        #
        # /whatever
        # /subdir/whatever
        request_dir  = File.split(relative_path).first
        request_path = File.join(request_dir, view.name)

        result[request_path] = view
        result[request_dir]  = view if view.name == 'index'

        result
      end
    end

    # Rack call interface.
    def call(env)
      request  = Rack::Request.new(env)
      response = Response.new

      if view = @views[normalized_request_path(request.path)]
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

    # Internal: Get a normalized version of the specified request path.
    #
    # path - Request path to normalize
    #
    # Returns a string.
    def normalized_request_path(path)
      if path == '/'
        path
      else
        path.chomp('/')
      end
    end
  end
end
