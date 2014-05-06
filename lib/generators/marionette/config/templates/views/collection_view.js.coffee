@<%= js_application_name %>.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  class Views.CollectionView extends Marionette.CollectionView
    # Override the item view event prefix
    itemViewEventPrefix: 'childview'