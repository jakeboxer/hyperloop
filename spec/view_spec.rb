require File.expand_path("../spec_helper", __FILE__)

describe Hyperloop::View do
  before :each do
    @html_view   = Hyperloop::View.new("spec/fixtures/simple/app/views/about.html")
    @erb_view    = Hyperloop::View.new("spec/fixtures/erb/app/views/about.html.erb")
    @layout_view = Hyperloop::View.new(
      "spec/fixtures/layouts/app/views/index.html.erb",
      "spec/fixtures/layouts/app/views/layouts/application.html.erb"
    )
    @partial_view = Hyperloop::View.new(
      "spec/fixtures/partials/app/views/index.html.erb",
      "spec/fixtures/partials/app/views/layouts/application.html.erb"
    )
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
  end

  describe "#render" do
    it "renders plain HTML files" do
      expect(text_in(@html_view.render, "h1")).to eql("About")
    end

    it "renders ERB files" do
      expect(text_in(@erb_view.render, "h1")).to eql("I was born on December 21")
    end

    it "renders ERB files in layouts" do
      html = @layout_view.render

      expect(text_in(html, "h1")).to eql("Layout Header")
      expect(text_in(html, "h2")).to eql("This is the root page!")
    end

    it "renders partials in ERB files" do
      html = @partial_view.render

      expect(text_in(html, "h1")).to eql("Partials work in this app")
      expect(text_in(html, "h2")).to eql("This part of the root page is not in a partial!")
      expect(text_in(html, "p")).to eql("This is coming from a partial.")
    end
  end
end
