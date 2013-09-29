class PreloadScreen
  constructor: ->
    @queue = new createjs.LoadQueue(true)
    @queue.installPlugin(createjs.Sound)
    @manifest = [
      { src: "assets/images/sound.png" }

      { id: "music.chipho",       src: "assets/music/chipho.mp3" }
      { id: "music.ideetje",      src: "assets/music/ideetje.mp3" }

      { id: "sound.beep",         src: "assets/sounds/beep.wav" }
      { id: "sound.next",         src: "assets/sounds/next.wav" }
      { id: "sound.squeak",       src: "assets/sounds/squeak.wav" }
      { id: "sound.death",        src: "assets/sounds/death1.wav" }
      { id: "sound.power1",       src: "assets/sounds/powerup1.wav" }
      { id: "sound.power2",       src: "assets/sounds/powerup2.wav" }
    ]

  load: =>
    @queue.loadManifest(@manifest)

class PreloadScreenController
  constructor: (@app) ->
    @model = new PreloadScreen()
    @view  = new PreloadScreenView(this, @app.stage)

  run: =>
    @model.queue.on 'progress', (e) => @view.setProgress(e.loaded)
    @model.queue.on 'complete', =>
      @app.sound.initialize()
      @view.setProgress(1)
      @view.remove =>
        @view = null
        @model = null
        @app.controller = new MainMenuController(@app)
        @app.controller.run()
    @model.load()

class PreloadScreenView extends View
  initialize: =>
    @stage.addChild(@container)

    text = new createjs.Text("Loading", "30px Play", "#000")
    bounds = text.getBounds()
    text.x = 450 - bounds.width / 2
    text.y = 250 - bounds.height / 2
    @container.addChild text

    @loadingBar = new LoadingBar(600, 50, 5)
    @loadingBar.x = 450 - @loadingBar.width / 2
    @loadingBar.y = 300 - @loadingBar.height / 2
    @container.addChild @loadingBar

  setProgress: (percent) =>
    percent = 1 if percent > 1
    @loadingBar.setProgress percent

  remove: (callback) =>
    createjs.Tween.get(@container)
      .to(alpha: 0, 500).call =>
        @stage.removeChild @container
        callback()
