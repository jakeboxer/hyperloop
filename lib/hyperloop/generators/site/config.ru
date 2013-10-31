# This file is used by Rack-based servers to start the application.

require "hyperloop"
run Hyperloop::Application.new(File.dirname(__FILE__))
