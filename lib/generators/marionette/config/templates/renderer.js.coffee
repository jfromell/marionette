do (Handlebars, Marionette) ->

  Marionette.Handlebars =
    path: 'assets/backbone/templates/'
    extension: '.hbs'

  Marionette.TemplateCache.prototype.load = ->
    if @compiledTemplate
      @compiledTemplate

    if Handlebars.templates and Handlebars.templates[@templateId]
      @compiledTemplate = Handlebars.templates[@templateId]
    else
      template = @loadTemplate(@templateId)
      @compiledTemplate = @compileTemplate(template)

    @compiledTemplate

  Marionette.TemplateCache.prototype.loadTemplate = ->
    try
      template = Marionette.$(templateId).html
    catch e

    if not template or template.length is 0
      templateUrl = Marionette.Handlebars.path + templateId + Marionette.Handlebars.extension

      Marionette.$.ajax(
        url: templateUrl
        success: (data) ->
          template = data
        async: false
      )

      if not template or template.length is 0
        throw 'NoTemplateError - Could not find template: "' + templateUrl + '"'

    template

  Marionette.TemplateCache.prototype.compileTemplate = (rawTemplate) ->
    Handlebars.compile(rawTemplate)