require "thor"

module Hyperloop
  class CLI < Thor
    desc "new SITENAME", "Create a new Hyperloop site. \"rails new my_site\" creates a new site called MySite in \"./my_site\""
    def new(name)
      puts "you tried to make a site named #{name}! this isn't implemented yet! lol!"
    end
  end
end
