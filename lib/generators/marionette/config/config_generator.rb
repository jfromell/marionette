require 'generators/marionette/resource_helpers'

module Marionette
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      include Marionette::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      def create_renderer
        if yes? 'Use Handlebars as templating engine? (y/n)'
          template 'renderer.js.coffee', "#{config_path}/marionette/renderer.js.coffee"
        end
      end

      def create_base_entities
        template 'model.js.coffee', "#{lib_path}/entities/model.js.coffee"
        template 'collection.js.coffee', "#{lib_path}/entities/collection.js.coffee"
      end

      def create_base_controller
        template 'base_controller.js.coffee', "#{lib_path}/controllers/base_controller.js.coffee"
      end

      def create_base_views
        %w{view item_view layout collection_view composite_view}.each do |view|
          template "views/#{view}.js.coffee", "#{lib_path}/views/#{view}.js.coffee"
        end
      end

      def create_utilities
        %w{when_fetched}.each do |util|
          template "utilities/#{util}.js.coffee", "#{lib_path}/utilities/#{util}.js.coffee"
        end
      end
    end
  end
end