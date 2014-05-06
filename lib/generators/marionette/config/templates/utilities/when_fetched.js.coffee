@<%= js_application_name %>.module "Utilities", (Utilities, App, Backbone, Marionette, $, _) ->

  App.commands.setHandler 'when:fetched', (entities, callback) ->
    xhrs = _.chain([entities]).flatten().pluck('_fetch').value()

    # Run the callback when fetch promises are done
    $.when(xhrs...).done ->
      callback()