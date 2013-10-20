describe Hyperloop::View::Registry do
  before :each do
    @registry = Hyperloop::View::Registry.new("spec/fixtures/partials/")
  end

  describe "#find_template_view" do
    it "finds the root view" do
      expect(@registry.find_template_view("/").name).to eql("index")
    end

    it "finds a root view in a subdirectory" do
      expect(@registry.find_template_view("/subdir").name).to eql("index")
    end

    it "finds a non-root view in a subdirectory" do
      expect(@registry.find_template_view("/subdir/nonroot").name).to eql("nonroot")
    end

    it "doesn't find partials" do
      expect(@registry.find_template_view("/subdir/partial")).to be_nil
      expect(@registry.find_template_view("/subdir/_partial")).to be_nil
      expect(@registry.find_template_view("subdir/partial")).to be_nil
      expect(@registry.find_template_view("subdir/_partial")).to be_nil
    end

    it "doesn't find layouts" do
      expect(@registry.find_template_view("/layouts/application")).to be_nil
    end
  end

  describe "#find_partial_view" do
    it "finds partials" do
      expect(@registry.find_partial_view("subdir/partial").name).to eql("partial")
    end

    it "doesn't find partials if the filename in the path is prefixed with an underscore" do
      expect(@registry.find_partial_view("subdir/_partial")).to be_nil
    end

    it "doesn't find partials if the path is prefixed with a forward slash" do
      expect(@registry.find_partial_view("/subdir/partial")).to be_nil
    end

    it "doesn't find template views" do
      expect(@registry.find_partial_view("/")).to be_nil
      expect(@registry.find_partial_view("/subdir")).to be_nil
      expect(@registry.find_partial_view("/subdir/nonroot")).to be_nil
      expect(@registry.find_partial_view("subdir/nonroot")).to be_nil
    end

    it "doesn't find layouts" do
      expect(@registry.find_partial_view("/subdir/layouts/application")).to be_nil
      expect(@registry.find_partial_view("subdir/layouts/application")).to be_nil
    end
  end
end
