class LoadingBar extends createjs.Container
  constructor: (@width, @height, @stroke) ->
    @initialize()

  initialize: =>
    super
    outer = new createjs.Shape()
    # TODO: figure out moveTo, and why we need to retrace the first
    # line to fully enclose the shape
    outer.graphics.setStrokeStyle(@stroke).beginStroke("#000")
      .moveTo(0, 0)
      .lineTo(@width, 0).lineTo(@width, @height)
      .lineTo(0, @height).lineTo(0, 0)
      .lineTo(@width, 0)
    @addChild outer

    innerWidth  = @width  - @stroke * 2
    innerHeight = @height - @stroke * 2
    @inner = new createjs.Shape()
    @inner.graphics.beginFill("#000")
      .drawRect(0, 0, innerWidth, innerHeight)
    @inner.x = outer.x + @stroke
    @inner.y = outer.y + @stroke
    @inner.scaleX = 0.0
    @addChild @inner

  setProgress: (percent) =>
    @inner.scaleX = percent
