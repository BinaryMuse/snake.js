class SoundController
  constructor: (@app) ->
    @view = new SoundView(this, @app.stage)

  run: =>

  soundEnabled: =>
    !@app.sound.muted

  toggleSound: =>
    @app.sound.toggleMute()
    @view.setSoundEnabled(@soundEnabled())

class SoundView extends View
  initialize: =>
    @container.alpha = 0

    @bitmap = new createjs.Bitmap("assets/images/sound.png")
    @bitmap.scaleX = @bitmap.scaleY = 0.25
    @bitmap.x = 10
    @bitmap.y = 565
    @bitmap.cursor = "pointer"

    if @controller.soundEnabled()
      @bitmap.alpha = 1
    else
      @bitmap.alpha = 0.25

    @bitmap.on 'click', =>
      @controller.toggleSound()

    @container.addChild(@bitmap)
    @stage.addChild(@container)
    createjs.Tween.get(@container)
      .to(alpha: 1, 250)

  setSoundEnabled: (enabled) =>
    alpha = if enabled then 1 else 0.25
    createjs.Tween.get(@bitmap, override: true)
      .to(alpha: alpha, 500)

createTitlePortion = (text) ->
  @container = new createjs.Container()

  rect = new createjs.Shape()
  rect.graphics.beginFill("#eee").beginStroke("#eee")
    .drawRect(0, 0, 900, 300)

  temp = new createjs.Text("PLACEHOLDER", "100px Arial", "#ddd")
  bounds = temp.getBounds()
  temp.regX = bounds.width / 2
  temp.regY = bounds.height / 2
  temp.x = 450
  temp.y = 150
  temp.rotation = -15

  text = new createjs.Text(text.toUpperCase(), "100px Play", '#000')
  bounds = text.getBounds()
  text.regX = bounds.width / 2
  text.regY = bounds.height / 2
  text.x = 450
  text.y = 150

  @container.addChild rect
  @container.addChild temp
  @container.addChild text

  return @container
