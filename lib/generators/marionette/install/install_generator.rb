require 'generators/marionette/resource_helpers'

module Marionette
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Marionette::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      class_option :config, type: :boolean, default: true, description: 'Invokes Marionette base configuration'

      def name_your_app
        if no? "The default marionette application name is: #{suggested_app_name} -- Is this ok? (y/n)"
          @app_name = ask("What would you like to name your Marionette application?").camelize
        end

        template 'marionette.rb', 'config/initializers/marionette.rb'
        Rails.configuration.marionette = { app_name: "#{suggested_app_name}" }
      end

      def use_handlebars?
        if yes? "Use Handlebars as the template engine?"
          @using_handlebars = true

          external_libs[:handlebars] = 'http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-v1.3.0.js'
        end
      end

      def get_vendor_dependencies
        external_libs.each do |name, lib|
          get lib, "vendor/assets/javascripts/#{name}.js"
        end
      end

      def append_vendor_dependencies
        external_libs.each do |name, lib|
          append_to_file "#{javascript_path}/application.js" do
            "\n//= require #{name}"
          end
        end
      end

      def create_directory_layout
        %w{config backbone}.each do |dir|
          empty_directory "#{javascript_path}/#{dir}"
        end

        %w{apps entities templates lib}.each do |dir|
          empty_directory "#{backbone_path}/#{dir}"
        end

        %w{components controllers entities utilities views}.each do |dir|
          empty_directory "#{lib_path}/#{dir}"
        end
      end

      def patch_backbone_sync?
        if yes? "Patch Backbone.sync? (y/n)"
          template 'config/backbone/sync.js', "#{config_path}/backbone/sync.js"
        end
      end

      def patch_marionette_renderer
        if @using_handlebars
          template 'config/marionette/renderer.js.coffee', "#{config_path}/marionette/renderer.js.coffee"
        end
      end

      def create_app_file
        template 'backbone/app.js.coffee', "#{backbone_path}/app.js.coffee"
      end

      def use_lib_files?
        if yes? 'Use namespaced and patched views, controllers, models and collections? (y/n)'
          # Patched views
          %w{view item_view composite_view collection_view layout}.each do |view|
            template "lib/views/#{view}.js.coffee", "#{lib_path}/views/#{view}.js.coffee"
          end

          # Patched controllers
          template "lib/controllers/base.js.coffee", "#{lib_path}/controllers/base.js.coffee"

          # Patched entities
          %w{model collection}.each do |entity|
            template "lib/entities/#{entity}.js.coffee", "#{lib_path}/entities/#{entity}.js.coffee"
          end
        end
      end

      def append_app_dependencies
        append_to_file "#{javascript_path}/application.js" do
          "\n//" +
          "\n// Patches etc." +
          "\n//= require_tree config"+
          "\n//" +
          "\n// App startup" +
          "\n//= require backbone/app" +
          "\n//" +
          "\n// App files" +
          "\n//= require_tree backbone/lib" +
          "\n//= require_tree backbone/entities" +
          "\n//= require_tree backbone/apps" +
          "\n//"
        end
      end

      private

      def suggested_app_name
        @app_name || rails_application_name
      end
    end
  end
end