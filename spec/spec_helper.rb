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
  # Examples:
  #
  #   change_fixture("tmp/spec/fixtures/erb", "app/views/index.html.erb",
  #     :pattern     => "<title>ERB</title>",
  #     :replacement => "<title>Changed</title>"
  #   )
  #
  #   change_fixture("tmp/spec/fixtures/erb", "app/views/index.html.erb",
  #     :pattern     => /<title>[^<]*<\/title>/,
  #     :replacement => "<title>Changed</title>"
  #   )
  #
  # Returns nothing.
  def change_fixture(fixture_path, file_path, options = {})
    pattern     = options[:pattern]
    replacement = options[:replacement]

    raise ArgumentError, "change_fixture must include a :pattern option" unless pattern
    raise ArgumentError, "change_fixture must include a :replacement option" unless replacement

    File.open(File.join(fixture_path, file_path), "r+") do |f|
      data = f.read.sub(pattern, replacement)
      f.rewind
      f.write(data)
    end
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
  # Note:
  #
  #   This method exists along with change_fixture and cleanup_fixtures. If
  #   these get used a lot more or more fixture-related functionality is added,
  #   it may make sense to extract a Fixture class and move these methods into
  #   it.
  #
  # Returns a string filepath representing the new location of the prepared
  # fixture.
  def prepare_fixture(name)
    root     = File.join("spec", "fixtures", name.to_s)
    contents = File.join(root, ".")
    tmp_root = File.join("tmp", root)

    # Delete and recreate the tmp/spec/fixtures/:name directory, then copy the
    # fixture into it.
    FileUtils.rm_rf(tmp_root)
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

  def mock_request(app = nil)
    Rack::MockRequest.new(app || mock_app)
  end
end

ENV["RACK_ENV"] ||= "test"

RSpec.configure do |c|
  c.include(Helpers)

  c.after :all do
    cleanup_fixtures
  end
end
