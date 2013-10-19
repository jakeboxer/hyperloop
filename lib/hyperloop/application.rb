require "rack"
require "sprockets"

module Hyperloop
  class Application
    include Rack::Utils

    def initialize(root=nil)
      @root          = root
      @view_registry = View::Registry.new(@root)
    end

    # Rack call interface.
    def call(env)
      request      = Rack::Request.new(env)
      response     = Response.new
      request_path = normalized_request_path(request.path)
      filename     = File.basename(request.path)

      if self.class.asset_path?(request_path) && asset = assets[filename]
        # If the path is for an asset, find the specified asset and use its data
        # as the response body.
        response["Content-Type"] = asset.content_type
        response.write(asset.source)
      elsif view = @view_registry.find_template_view(request_path)
        # If there's a view at the path, use its data as the response body.
        data = view.render(request)
        response.write(data)
      else
        # If there's no view at the path, 404.
        response.status = 404
      end

      response.finish
    end

    private

    # Internal: Is the specified path for assets?
    #
    # path - Path to check.
    #
    # Returns a boolean.
    def self.asset_path?(path)
      path.start_with?("/assets/")
    end

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
      if path == "/"
        path
      else
        path.chomp("/")
      end
    end
  end
end
