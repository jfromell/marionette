do (Marionette) ->

  _remove = Marionette.View::remove

  _.extend Marionette.View::,
    remove: (args...) ->
      console.log 'Removing view: ', @
      _remove.apply @, args