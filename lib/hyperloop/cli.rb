require "hyperloop/generators/site"
require "thor"

module Hyperloop
  class CLI < Thor
    desc "new SITENAME", "Create a new Hyperloop site. \"rails new my_site\" creates a new site called MySite in \"./my_site\""
    def new(name)
      Hyperloop::Generators::Site.start([name])
    end
  end
end
