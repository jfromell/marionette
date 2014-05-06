do (Backbone) ->
  _sync = Backbone.sync

  Backbone.sync = (method, entity, options) ->
    # Run callback before sending
    _beforeSend = options.beforeSend
    options.beforeSend = ->
      entity.trigger 'sync:start', entity
      _beforeSend()

    # Run callback when complete
    _complete = options.complete
    options.complete = ->
      entity.trigger 'sync:stop', entity
      _complete()

    # This is to work with Strong Parameters, it wraps the data in
    # a `paramRoot` parameter that is set in the model
    if options.data is undefined and entity and (method is 'create' or method is 'update' or method is 'patch')
      data = {}

      if entity.paramRoot
        data[entity.paramRoot] = entity.toJSON(options)
      else
        data = entity.toJSON()

      _.extend options,
        contentType: 'application/json'
        data: data

    # Always return a Backbone.sync promise, even on `read`
    if not entity._fetch and method is 'read'
      entity._fetch = _sync

    _sync