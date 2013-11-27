require "nokogiri"
require "pry"

require "hyperloop"

module Helpers
  # Public: Clean up all prepared fixtures.
  #
  # Returns nothing.
  def cleanup_fixtures
    tmp_fixtures_dir = File.join("tmp", "spec", "fixtures")
    FileUtils.rm_rf(tmp_fixtures_dir)
  end

  def html(str)
    Nokogiri::HTML(str)
  end

  def mock_view_registry
    @mock_view_registry ||= double("Hyperloop::View::Registry",
      :find_partial_view  => nil,
      :find_template_view => nil
    )
  end

  # Public: Prepare a fixture with the specified name.
  #
  # name - Symbol name of the fixture to prepare. The name passed here will be
  #        looked up in the spec/fixtures directory.
  #
  # Returns a string filepath representing the new location of the prepared
  # fixture.
  def prepare_fixture(name)
    root     = File.join("spec", "fixtures", name.to_s)
    contents = File.join(root, ".")
    tmp_root = File.join("tmp", root)

    # Create the tmp/spec/fixtures/:name directory and copy the fixture into it.
    FileUtils.mkdir_p(tmp_root)
    FileUtils.cp_r(contents, tmp_root)

    tmp_root
  end

  def text_in(html_str, selector)
    node = html(html_str).at_css(selector)
    node && node.text
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
