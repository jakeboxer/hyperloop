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

  # Public: Change the contents of a file in a fixture.
  #
  # fixture_path - Path to the fixture containing the file we want to change.
  # file_path    - Path (relative to fixture_path) of the file we want to
  #                change.
  # options      - Hash containing the following keys:
  #                :pattern     - (Required) Regexp or String to find in the
  #                               file. Only the first occurrence will be
  #                               matched.
  #                :replacement - (Required) String to replace the found pattern
  #                               with.
  #
  # Returns nothing.
  def change_fixture(fixture_path, file_path, options = {})
    pattern     = options[:pattern]
    replacement = options[:replacement]

    raise ArgumentError, "change_fixture must include a :pattern option" unless pattern
    raise ArgumentError, "change_fixture must include a :replacement option" unless replacement

    full_file_path = File.join(fixture_path, file_path)
    data           = File.read(full_file_path).sub(pattern, replacement)
    File.write(full_file_path, data)
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

  # Public: Set the RACK_ENV environment variable back to whatever it was when
  # the spec started running. If RACK_ENV wasn't set before the spec started
  # running, it will be deleted.
  #
  # Returns nothing.
  def reset_rack_env
    if defined?(@old_rack_env)
      ENV["RACK_ENV"] = @old_rack_env
    else
      ENV.delete("RACK_ENV")
    end
  end

  # Public: Set the RACK_ENV environment variable to the specified value.
  #
  # name - Symbol environment name to set RACK_ENV to. Should be :development,
  #        :test, or :production.
  #
  # Returns nothing.
  def set_rack_env(name)
    @old_rack_env = ENV["RACK_ENV"] if ENV.key?("RACK_ENV")
    ENV["RACK_ENV"] = name.to_s
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
