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
        # some/path/app/views/subdir/_partial.html.erb
        view_paths = Dir.glob(@views_root + "/**/*").reject {|fn| File.directory?(fn)}
        view_paths -= [layout_path]

        @template_views = {}
        @partial_views  = {}

        view_paths.each do |path|
          view = View.new(path, layout_path)

          # The path under app/views. This will be something like:
          #
          # /whatever.html.erb
          # /subdir/whatever.html.erb
          # /subdir/_partial.html.erb
          relative_path = path.sub(@views_root, "")

          # The path under app/views without a file extension (and without the
          # starting _ for partials). This will be something like:
          #
          # /whatever
          # /subdir/whatever
          # /subdir/partial
          request_dir  = File.dirname(relative_path)
          request_path = File.join(request_dir, view.name)

          if view.partial?
            @partial_views[request_path] = view
          else
            @template_views[request_path] = view
            @template_views[request_dir]  = view if view.name == "index"
          end
        end
      end

      def find_template_view(path)
        @template_views[path]
      end
    end
  end
end
