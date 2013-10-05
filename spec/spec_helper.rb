require 'nokogiri'
require 'pry'

require 'hyperloop'

module Helpers
  def html(str)
    Nokogiri::HTML(str)
  end

  def text_in(html_str, selector)
    node = html(html_str).at_css(selector)
    raise "Selector #{selector.inspect} not found in:\n\n#{html_str.inspect}" unless node
    node.text
  end
end

RSpec.configure do |c|
  c.include(Helpers)
end
