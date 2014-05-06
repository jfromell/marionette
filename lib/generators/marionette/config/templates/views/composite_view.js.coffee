@<%= js_application_name %>.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  class Views.CompositeView extends Marionette.CompositeView
    # Override the item view event prefix
    itemViewEventPrefix: 'childview'