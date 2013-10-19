module Hyperloop
  class View
    class Registry
      def initialize(root)
        @root       = root
        @views_root = File.join([@root, "app/views"].compact)
        layout_path = @views_root + "/layouts/application.html.erb"

        # Get all the view paths. These look like:
        #
        # some/path/app/views/whatever.html.erb
        # some/path/app/views/subdir/whatever.html.erb
        view_paths = Dir.glob(@views_root + "/**/*").reject {|fn| File.directory?(fn)}

        @views = view_paths.inject({}) do |result, path|
          view = View.new(path, layout_path)

          # The path under app/views. This will be something like:
          #
          # /whatever.html.erb
          # /subdir/whatever.html.erb
          relative_path = path.sub(@views_root, "")

          # The path under app/views without a file extension. This will be
          # something like:
          #
          # /whatever
          # /subdir/whatever
          request_dir  = File.split(relative_path).first
          request_path = File.join(request_dir, view.name)

          result[request_path] = view
          result[request_dir]  = view if view.name == "index"

          result
        end
      end

      def find_template_view(path)
        @views[path]
      end
    end
  end
end
