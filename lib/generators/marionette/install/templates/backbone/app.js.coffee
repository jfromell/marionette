@<%= js_application_name %> = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.addRegions
    mainRegion: '#main-region'

  App.reqres.setHandler 'default:region', ->
    App.mainRegion

  App.on 'initialize:after', (options) ->
    if Backbone.history
      Backbone.history.start()

  App