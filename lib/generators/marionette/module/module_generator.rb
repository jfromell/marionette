require 'generators/marionette/resource_helpers'

module Marionette
  module Generators
    class ModuleGenerator < Rails::Generators::NamedBase
      include Marionette::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      # You may supply any actions you intend to use in this module here
      arguments :actions, type: :array, default: [], banner: 'action action'

      def create_module
        template 'module.js.coffee', "#{backbone_path}/apps/#{module_name_underscored}/#{module_name_underscored}_app.js.coffee"
      end

      def create_controllers
        actions.each do |action|
          @action = action.capitalize
          template 'module/controller.js.coffee', "#{backbone_path}/apps/#{module_name_underscored}/#{action}/#{action}_controller.js.coffee"
        end
      end

      def create_views
        actions.each do |action|
          @action = action.capitalize
          template 'module/view.js.coffee', "#{backbone_path}/apps/#{module_name_underscored}/#{action}/#{action}_view.js.coffee"
        end
      end

      private

      def module_routes
        actions.inject({}) do |route, action|
          route[lookup(action)] = action
          route
        end
      end

      def lookup(action)
        {
          list: resource_name
          "new": "#{resource_name}/new"
          show: "#{resource_name}/:id"
          edit: "#{resource_name}/:id/edit" 
        }[action.to_sym] || 'change_me'
      end

      def resource_name
        file_name.downcase.pluralize
      end
    end
  end
end