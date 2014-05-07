@<%= js_application_name %>.module "<%= module_name %>", (<%= module_name %>, App, Backbone, Marionette, $, _) ->

  class <%= module_name %>.Router extends Marionette.AppRouter
    appRoutes:
    <% module_routes.each do |key, val| -%>
      "<%= key %>" : "<%= val %>"
    <% end -%>

  API =
  <% actions.each do |action| -%>
    <%= action %>: ->
      new <%= module_name %>.<%= action.capitalize %>.Controller
  <% end -%>

  App.addInitializer ->
    new <%= module_name %>.Router
      controller: API