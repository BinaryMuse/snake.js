class GameController
  constructor: (@app, @options) ->

  run: =>
    @setupKeyHandlers()
    @app.sound.playMusic('ideetje')

  setupKeyHandlers: =>
    $(document).on 'keydown', @handleKey

  removeKeyHandlers: =>
    $(document).off 'keydown', @handleKey

  handleKey: (evt) =>
