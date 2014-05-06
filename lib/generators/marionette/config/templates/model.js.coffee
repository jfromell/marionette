@<%= js_application_name %>.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Model extends Backbone.Model

    # Override toJSON to comply with Rails strong parameters
    toJSON: (options = {}) ->
      data  = {}
      attrs = _.clone(@attributes)

      if options and options.includeParamRoot and @paramRoot
        data[@paramRoot] = attrs
      else
        data = attrs

      data

    destroy: (options = {}) ->
      _.defaults options,
        wait: true # Wait for server to respond
      
      # For Rails
      @set _destroy: true

      # Run super function
      super(options)

      # Trigger events
      @collection?.trigger 'model:destroyed', @
      @trigger 'destroyed', @

    save: (data, options = {}) ->
      _.defaults options,
        wait: true # Wait for server to respond
        success: _.bind(@_saveSuccess, @, @isNew(), options.collection, options.callback)
        error:   _.bind(@_saveError,   @)

      # Remove lingering errors
      @unser '_errors'

      # Run super function
      super(data, options)

    # Callbacks
    _saveSuccess: (isNew, collection, callback) ->
      if isNew
        # Model is being created

        # Add it to the collection, if it exists
        collection?.add @

        # Trigger events
        collection?.trigger 'model:created', @
        @trigger 'created', @
      else
        # Model is being updated

        # Trigger events
        @collection?.trigger 'model:updated', @
        @trigger 'updated', @

      # Run the success callback
      callback?()

    _saveError: (model, xhr, options) ->
      # Set errors
      @set _errors: $.parseJSON(xhr.responseText)?.errors unless /500|404/.test xhr.status

  API =
    new: (attrs) ->
      new Entities.Model attrs

  App.reqres.setHandler 'new:model', (attrs = {}) ->
    API.new(attrs)