require 'thor/group'

module Hyperloop
  module Generators
    class Site < Thor::Group
      include Thor::Actions

      argument :group, :type => :string
      argument :name, :type => :string

      def self.source_root
        File.join(File.dirname(__FILE__), "site")
      end

      def create_group
        empty_directory(group)
      end

      def copy_root
        template("index.html.erb", "#{group}/#{name}/index.html.erb")
      end
    end
  end
end
