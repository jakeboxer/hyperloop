require 'rack'

module Hyperloop
  class Application
    include Rack::Utils

    attr_reader :views

    def initialize(root='')
      @root  = root
      @views = Dir.entries(@root + 'app/views') - %w(. ..)
    end

    # Rack call interface.
    def call(env)
      @env      = env
      @request  = Request.new(env)
      @response = Response.new
    end
  end
end
