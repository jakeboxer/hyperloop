require 'nokogiri'
require 'hyperloop'

module Helpers
  def html(str)
    Nokogiri::HTML(str)
  end

  def text_in(html_str, selector)
    html(html_str).at_css(selector).text
  end
end

RSpec.configure do |c|
  c.include(Helpers)
end
