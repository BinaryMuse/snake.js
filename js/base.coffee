class View
  constructor: (@controller, @stage) ->
    @container = new createjs.Container()
    @initialize()
