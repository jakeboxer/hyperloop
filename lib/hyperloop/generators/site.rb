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
        empty_directory(File.join(name, "app", "views"))
        empty_directory(File.join(name, "app", "views", "layouts"))
      end

      def copy_files
        template("config.ru",            File.join(name, "config.ru"))
        template("Gemfile",              File.join(name, "Gemfile"))
        template("application.html.erb", File.join(name, "app", "views", "layouts", "application.html.erb"))
        template("index.html.erb",       File.join(name, "app", "views", "index.html.erb"))
        template("about.html.erb",       File.join(name, "app", "views", "about.html.erb"))
        template("_partial.html.erb",    File.join(name, "app", "views", "_partial.html.erb"))
      end
    end
  end
end
