class Submenu extends createjs.Container
  constructor: (@menu, @initialSelection = 0) ->
    @initialize()

  initialize: =>
    super
    @maxTextWidth = 0
    @texts = []

    if @menu.title
      titleText = new createjs.Text(@menu.title, '400 24px Play', 'black')
      bounds = titleText.getBounds()
      @maxTextWidth = bounds.width + 10 if bounds.width + 10 > @maxTextWidth
      titleText.x = 0
      titleText.y = -35
      line = new createjs.Shape()
      line.graphics.beginStroke('#000')
        .moveTo(-10, -5).lineTo(bounds.width + 10, -5)

      @addChild(titleText)
      @addChild(line)

    for option, i in @menu.options
      text = new createjs.Text(option.text, '400 24px Play', 'black')
      bounds = text.getBounds()
      @maxTextWidth = bounds.width if bounds.width > @maxTextWidth
      text.x = 0
      text.y = 30 * i
      @texts.push(text)
      @addChild text

    @cursor = new TriangleCursor
    @cursor.x = -25
    @setSelection(@initialSelection)
    @addChild @cursor

  setSelection: (idx) =>
    @cursor.y = @texts[idx].y + 4
