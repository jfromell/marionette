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

      def get_vendor_dependencies
        external_libs.each do |name, lib|
          get lib, "vendor/assets/javascripts/#{name}.js"
        end
      end

      def append_vendor_dependencies
        %w{underscore backbone marionette}.each do |lib|
          append_to_file "#{javascript_path}/application.js" do
            "\n//= require #{lib}"
          end
        end
      end

      def append_app_dependencies
        append_to_file "#{javascript_path}/application.js" do
          "\n// Patches etc." +
          "\n//= require_tree config\n" +
          "\n// App startup" +
          "\n//= require backbone/app\n" +
          "\n// App files" +
          "\n//= require_tree backbone/lib" +
          "\n//= require_tree backbone/entities" +
          "\n//= require_tree backbone/apps"
        end
      end

      def create_dir_layout
        %w{apps entities templates lib}.each do |dir|
          empty_directory "#{backbone_path}/#{dir}"
        end

        %w{components controllers entities utilities views}.each do |dir|
          empty_directory "#{lib_path}/#{dir}"
        end
      end

      def create_app_file
        template 'app.js.coffee', "#{backbone_path}/app.js.coffee"
      end

      def start_marionette_app
        destination = 'app/views/application/index.html.erb'
        create_file destination unless File.exists? destination
        append_to_file destination do
          embed_template 'index.html.erb'
        end
      end

      def invoke_config
        generate 'marionette:config'
      end

      private

      def suggested_app_name
        @app_name || rails_application_name
      end
    end
  end
end