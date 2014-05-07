@<%= js_application_name %>.module "<%= module_name %>", (<%= module_name %>, App, Backbone, Marionette, $, _) ->

  class <%= @action %>.Controller extends App.Controllers.Base

    initialize: ->