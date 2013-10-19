require "nokogiri"
require "pry"

require "hyperloop"

module Helpers
  def html(str)
    Nokogiri::HTML(str)
  end

  def mock_view_registry
    @mock_view_registry ||= double("Hyperloop::View::Registry",
      :find_partial_view  => nil,
      :find_template_view => nil
    )
  end

  def text_in(html_str, selector)
    node = html(html_str).at_css(selector)
    raise "Selector #{selector.inspect} not found in:\n\n#{html_str.inspect}" unless node
    node.text
  end

  def mock_app
    @mock_app ||= double("rack app", :call => Hyperloop::Response.new.finish )
  end

  def mock_request
    Rack::MockRequest.new(mock_app)
  end
end

RSpec.configure do |c|
  c.include(Helpers)
end
