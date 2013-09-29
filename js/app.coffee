class SoundManager
  constructor: (initiallyMuted) ->
    @muted = initiallyMuted

  # It appears volume must be set after preloading is complete
  initialize: =>
    @bg = null
    @volume = if @muted then 0 else 1
    createjs.Sound.setVolume(@volume)

  playMusic: (song) =>
    @bg = createjs.Sound.play("music.#{song}", loop: -1)

  playSound: (sound) =>
    createjs.Sound.play("sound.#{sound}")

  toggleMute: =>
    @mute(!@muted)

  mute: (muted) =>
    if muted
      localStorage.setItem("snakejs.mute", true)
    else
      localStorage.removeItem("snakejs.mute")

    @muted = muted
    vol = if muted then 0 else 1
    createjs.Tween.get(this, override: true)
      .to(volume: vol, 500)
      .on 'change', (e) =>
        createjs.Sound.setVolume(@volume)

  fadeBg: (time = 500, cb = ->) =>
    return cb() unless @bg
    createjs.Tween.get(@bg, override: true)
      .to(volume: 0, time)
      # .on 'change', (e) =>
      #   createjs.Sound.setVolume(@volume)

class Application
  constructor: ->
    @stage   = new createjs.Stage("game")
    @stage.x = 0.5
    @stage.y = 0.5
    @stage.enableMouseOver()
    createjs.Ticker.on 'tick', @stage

    if window.localStorage
      previouslyMuted = localStorage.getItem("snakejs.mute") || false
    else
      previouslyMuted = false

    @sound      = new SoundManager(previouslyMuted)
    window.s = @sound
    @controller = new PreloadScreenController(this)

  run: ->
    @controller.run()

jQuery ->
  app = new Application()
  app.run()
