@<%= js_application_name %>.module "Controllers", (Controllers, App, Backbone, Marionette, $, _) ->

  class Controllers.Base extends Marionette.Controller

    constructor: (options) ->
      # If no region in options, fall back to the default region
      @region = options.region or App.request 'default:region'

      # Run super function
      super

    close: ->
      # Run super function
      super

    show: (view, options) ->
      _.defaults options,
        region: @region

      # View can either be a view or a controller instance
      # Grab the `mainView` if controller instance
      view = view.mainView or view

      # Set this view as `mainView`
      @mainView = view

      # Listen to events
      @listenTo view, 'close', @close

      # Show the view
      options.region.show(view)

    setMainView: (view) ->
      unless @mainView
        @mainView = view
        @listenTo view, 'close', @close