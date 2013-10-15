require 'rack'
require 'sprockets'

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root=nil)
      @root       = root
      @views_root = File.join([@root, 'app/views'].compact)
      layout_path = @views_root + '/layouts/application.html.erb'

      # Get all the view paths. These look like:
      #
      # some/path/app/views/whatever.html.erb
      # some/path/app/views/subdir/whatever.html.erb
      view_paths = Dir.glob(@views_root + '/**/*').reject {|fn| File.directory?(fn)}

      @views = view_paths.inject({}) do |result, path|
        view = View.new(path, layout_path)

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
      request      = Rack::Request.new(env)
      response     = Response.new
      request_path = normalized_request_path(request.path)

      if request_path.start_with?('/assets/')
        # If the path is for an asset, find the specified asset and use its data
        # as the response body.
        filename = File.basename(request_path)
        response.write(assets[filename])
      elsif view = @views[request_path]
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

    # Internal: The sprockets environment for the app.
    #
    # Returns a Sprockets::Environment.
    def assets
      @assets ||= Sprockets::Environment.new do |env|
        env.append_path(@root + "/app/assets/images")
        env.append_path(@root + "/app/assets/javascripts")
        env.append_path(@root + "/app/assets/stylesheets")

        # compress everything in production
        if ENV["RACK_ENV"] == "production"
          env.js_compressor  = YUI::JavaScriptCompressor.new
          env.css_compressor = YUI::CssCompressor.new
        end
      end
    end

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
