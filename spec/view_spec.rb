require File.expand_path("../spec_helper", __FILE__)

describe Hyperloop::View do
  before :each do
    @html_view = Hyperloop::View.new(mock_view_registry,
      "spec/fixtures/simple/app/views/about.html"
    )

    @erb_view = Hyperloop::View.new(mock_view_registry,
      "spec/fixtures/erb/app/views/about.html.erb"
    )

    @layout_view = Hyperloop::View.new(mock_view_registry,
      "spec/fixtures/layouts/app/views/index.html.erb",
      "spec/fixtures/layouts/app/views/layouts/application.html.erb"
    )

    partials_view_registry = Hyperloop::View::Registry.new("spec/fixtures/partials/")
    @partial_container     = partials_view_registry.find_template_view("/")
    @partial_view          = partials_view_registry.find_partial_view("subdir/partial")
  end

  describe "#format" do
    it "is :html for HTML files" do
      expect(@html_view.format).to eql(:html)
    end

    it "is :erb for ERB files" do
      expect(@erb_view.format).to eql(:erb)
    end
  end

  describe "#name" do
    it "strips the extension from plain HTML files" do
      expect(@html_view.name).to eql("about")
    end

    it "strips the extension from ERB files" do
      expect(@erb_view.name).to eql("about")
    end

    it "strips the leading underscore for partials" do
      expect(@partial_view.name).to eql("partial")
    end
  end

  describe "#partial?" do
    it "is false for a template view" do
      expect(@partial_container).not_to be_partial
    end

    it "is true for a partial view" do
      expect(@partial_view).to be_partial
    end
  end

  describe "#render" do
    it "renders plain HTML files" do
      html = @html_view.render(mock_request)

      expect(text_in(html, "h1")).to eql("About")
    end

    it "renders ERB files" do
      html = @erb_view.render(mock_request)

      expect(text_in(html, "h1")).to eql("I was born on December 21")
    end

    it "renders ERB files in layouts" do
      html = @layout_view.render(mock_request)

      expect(text_in(html, "h1")).to eql("Layout Header")
      expect(text_in(html, "h2")).to eql("This is the root page!")
    end

    it "renders ERB files containing partials" do
      html = @partial_container.render(mock_request)

      expect(text_in(html, "h1")).to eql("Partials work in this app")
      expect(text_in(html, "h2")).to eql("This part of the root page is not in a partial!")
      expect(text_in(html, "p")).to eql("This is coming from a partial.")
    end
  end
end
