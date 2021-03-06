require "thor/group"
require "hyperloop/version"

module Hyperloop
  module Generators
    class Site < Thor::Group
      include Thor::Actions

      argument :name, :type => :string

      def self.source_root
        File.join(File.dirname(__FILE__), "site")
      end

      def create_directories
        empty_directory(name)
        empty_directory(File.join(name, "app"))
        empty_directory(File.join(name, "app", "assets"))
        empty_directory(File.join(name, "app", "assets", "images"))
        empty_directory(File.join(name, "app", "assets", "javascripts"))
        empty_directory(File.join(name, "app", "assets", "stylesheets"))
        empty_directory(File.join(name, "app", "views"))
        empty_directory(File.join(name, "app", "views", "layouts"))
        empty_directory(File.join(name, "vendor"))
        empty_directory(File.join(name, "vendor", "assets"))
        empty_directory(File.join(name, "vendor", "assets", "javascripts"))
        empty_directory(File.join(name, "vendor", "assets", "stylesheets"))
      end

      def copy_files
        template("config.ru",            File.join(name, "config.ru"))
        template("Gemfile",              File.join(name, "Gemfile"))
        copy_file("socool.jpg",          File.join(name, "app", "assets", "images", "socool.jpg"))
        template("app.js",               File.join(name, "app", "assets", "javascripts", "app.js"))
        template("current-time.coffee",  File.join(name, "app", "assets", "javascripts", "current-time.coffee"))
        template("app.css",              File.join(name, "app", "assets", "stylesheets", "app.css"))
        template("main.scss",            File.join(name, "app", "assets", "stylesheets", "main.scss"))
        template("application.html.erb", File.join(name, "app", "views", "layouts", "application.html.erb"))
        template("index.html.erb",       File.join(name, "app", "views", "index.html.erb"))
        template("about.html.erb",       File.join(name, "app", "views", "about.html.erb"))
        template("_partial.html.erb",    File.join(name, "app", "views", "_partial.html.erb"))
        template("jquery.js",            File.join(name, "vendor", "assets", "javascripts", "jquery.js"))
        template("bootstrap.css",        File.join(name, "vendor", "assets", "stylesheets", "bootstrap.css"))
      end
    end
  end
end
