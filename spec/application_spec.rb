require File.expand_path("../spec_helper", __FILE__)

describe Hyperloop::Application do
  describe "with a flat views directory" do
    before :each do
      @app = Hyperloop::Application.new(prepare_fixture(:simple))
    end

    it "responds successfully to a request for root" do
      response = mock_request(@app).get("/")

      expect(response).to be_ok
      expect(response.content_type).to eql("text/html")
      expect(text_in(response.body, "h1")).to eql("Simple")
    end

    it "responds successfully to a request for a different page" do
      response = mock_request(@app).get("/about")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("About")
    end

    it "responds successfully to a request with a trailing slash" do
      response = mock_request(@app).get("/about/")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("About")
    end

    it "404s on a request for a nonexistent page" do
      response = mock_request(@app).get("/nonexistent")

      expect(response).to be_not_found
    end
  end

  describe "with subdirectories" do
    before :each do
      @app = Hyperloop::Application.new(prepare_fixture(:subdirectories))
    end

    it "responds successfully to a request for the subdirectory root" do
      response = mock_request(@app).get("/subdir1")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("Subdirectory Index")
    end

    it "responds successfully to a request for a different page in the subdirectory" do
      response = mock_request(@app).get("/subdir1/kanye")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("Hurry up with my damn croissant")
    end
  end

  describe "with ERB" do
    before :each do
      @app = Hyperloop::Application.new(prepare_fixture(:erb))
    end

    it "renders embedded Ruby in the root page" do
      response = mock_request(@app).get("/")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("WE ARE USING ERB")
    end
  end

  describe "with a layout" do
    before :each do
      @app = Hyperloop::Application.new(prepare_fixture(:layouts))
    end

    it "renders the root view within the layout" do
      response = mock_request(@app).get("/")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("Layout Header")
      expect(text_in(response.body, "h2")).to eql("This is the root page!")
    end

    it "renders subdirectory views within the layout" do
      response = mock_request(@app).get("/subdir")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("Layout Header")
      expect(text_in(response.body, "h2")).to eql("This is a page in a subdirectory!")
    end
  end

  describe "with assets" do
    before :each do
      @app = Hyperloop::Application.new(prepare_fixture(:assets))
    end

    it "responds successfully to a request for root" do
      response = mock_request(@app).get("/")

      expect(response).to be_ok
      expect(text_in(response.body, "h1")).to eql("This app has so many assets")
    end

    it "responds successfully to a request for the css app bundle" do
      response = mock_request(@app).get("/assets/stylesheets/app.css")

      expect(response).to be_ok
      expect(response.content_type).to eql("text/css")
      expect(response.body).to match(/display: ?block/)
    end

    it "responds successfully to a request for the javascript app bundle" do
      response = mock_request(@app).get("/assets/javascripts/app.js")

      expect(response).to be_ok
      expect(response.content_type).to eql("application/javascript")
      expect(response.body).to match(/alert\("such javascript wow"\)/)
    end

    it "responds successfully to a request for a vendored css file" do
      response = mock_request(@app).get("/assets/stylesheets/vendored.css")

      expect(response).to be_ok
      expect(response.content_type).to eql("text/css")
      expect(response.body).to match(/margin: ?0/)
    end

    it "responds successfully to a request for a vendored javascript bundle" do
      response = mock_request(@app).get("/assets/javascripts/vendored.js")

      expect(response).to be_ok
      expect(response.content_type).to eql("application/javascript")
      expect(response.body).to match(/alert\("i am vendored"\)/)
    end

    it "responds successfully to a request for a gif" do
      response = mock_request(@app).get("/assets/images/my-gif.gif")

      expect(response).to be_ok
      expect(response.content_type).to eql("image/gif")
      expect(Digest::SHA1.hexdigest(response.body)).to eql("bcbc6e6fc1eb77b2ca676e17425df93a56495bb2")
    end

    it "responds successfully to a request for a jpg" do
      response = mock_request(@app).get("/assets/images/my-jpg.jpg")

      expect(response).to be_ok
      expect(response.content_type).to eql("image/jpeg")
      expect(Digest::SHA1.hexdigest(response.body)).to eql("ae6a26b513d6648446da1395ee73e9cf32c8c668")
    end

    it "responds successfully to a request for a png" do
      response = mock_request(@app).get("/assets/images/my-png.png")

      expect(response).to be_ok
      expect(response.content_type).to eql("image/png")
      expect(Digest::SHA1.hexdigest(response.body)).to eql("adf65c25a8e3e39c49ecf581433278d7eac4d1a2")
    end

    it "404s on a request for an asset without namespacing by type" do
      response = mock_request(@app).get("/assets/app.js")
      expect(response).to be_not_found
    end

    it "404s on a request for an asset namespaced by the wrong type" do
      response = mock_request(@app).get("/assets/stylesheets/app.js")
      expect(response).to be_not_found
    end

    it "404s on a request for an asset namespaced by an unknown type" do
      response = mock_request(@app).get("/assets/shouldfail/shouldfail.css")
      expect(response).to be_not_found
    end

    it "404s on a request for a nonexistent asset" do
      response = mock_request(@app).get("/assets/javascripts/nonexistent.js")

      expect(response).to be_not_found
    end
  end

  describe "live reloading" do
    context "with assets" do
      before :each do
        @root = prepare_fixture(:assets)
        @app  = Hyperloop::Application.new(@root)
      end

      it "reloads changed assets" do
        # On the first request, stylesheet should have `display: block` and not
        # `display: inline`.
        response = mock_request(@app).get("/assets/stylesheets/app.css")
        expect(response).to be_ok
        expect(response.body).to match(/display: ?block/)
        expect(response.body).not_to match(/display: ?inline/)

        change_fixture(@root, "app/assets/stylesheets/my-styles.scss",
          :pattern     => "display: block",
          :replacement => "display: inline"
        )

        # On the second request, stylesheet should have `display: inline` and not
        # `display: block`.
        response = mock_request(@app).get("/assets/stylesheets/app.css")
        expect(response).to be_ok
        expect(response.body).to match(/display: ?inline/)
        expect(response.body).not_to match(/display: ?block/)
      end
    end

    context "with views" do
      before :each do
        @root = prepare_fixture(:partials)
        @app  = Hyperloop::Application.new(@root)
      end

      it "reloads changed layouts" do
        # On the first request, <title> text should not be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "title")).not_to eql("Changed")

        change_fixture(@root, "app/views/layouts/application.html.erb",
          :pattern     => /<title>[^<]*<\/title>/,
          :replacement => "<title>Changed</title>"
        )

        # On the second request, <title> text should be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "title")).to eql("Changed")
      end

      it "reloads changed partials" do
        # On the first request, <p> text should not be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "p.spec-in-partial")).not_to eql("Changed")

        change_fixture(@root, "app/views/subdir/_partial.html.erb",
          :pattern     => /<p class="spec-in-partial">[^<]*<\/p>/,
          :replacement => "<p class=\"spec-in-partial\">Changed</p>"
        )

        # On the second request, <p> text should be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "p.spec-in-partial")).to eql("Changed")
      end

      it "reloads changed views" do
        # On the first request, <h2> text should not be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "h2")).not_to eql("Changed")

        change_fixture(@root, "app/views/index.html.erb",
          :pattern     => /<h2>[^<]*<\/h2>/,
          :replacement => "<h2>Changed</h2>"
        )

        # On the second request, <h2> text should be "Changed"
        response = mock_request(@app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "h2")).to eql("Changed")
      end
    end

    context "in production" do
      before :each do
        set_rack_env :production
      end

      after :each do
        reset_rack_env
      end

      it "doesn't reload changed views" do
        root = prepare_fixture(:erb)
        app  = Hyperloop::Application.new(root)

        # On the first request, <title> text should be "ERB"
        response = mock_request(app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "title")).to eql("ERB")

        change_fixture(root, "app/views/index.html.erb",
          :pattern     => "<title>ERB</title>",
          :replacement => "<title>Changed</title>"
        )

        # On the second request, <title> text should still be "ERB"
        response = mock_request(app).get("/")
        expect(response).to be_ok
        expect(text_in(response.body, "title")).to eql("ERB")
      end
    end
  end
end
