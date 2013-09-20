require 'rack'

module Hyperloop
  class Response < Rack::Response
    def initialize(*)
      super
      headers['Content-Type'] ||= 'text/html'
    end
  end
end
