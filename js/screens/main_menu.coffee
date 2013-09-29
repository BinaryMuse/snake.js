Menus =
  main:
    options: [
      { text: 'DEBUG', img: 'title', action: 'startgame' }
      { text: 'Play 1 Player', img: 'title', modify: { players: 1 }, menu: '>1p' }
      { text: 'Play 2 Player', img: 'title', modify: { players: 2 }, menu: '>2p' }
      { text: 'High Scores',   img: 'title', action: 'showscores' }
    ]

  '1p':
    title: 'Select 1 Player Mode'
    options: [
      { text: 'Classic', modify: { mode: 'classic' }, img: '1p_classic', menu: '>1p_classic' }
      { text: 'Time Attack', modify: { mode: 'time' }, img: '1p_time', menu: '>1p_time' }
      { text: 'Back', img: 'title', go: 'back' }
    ]

  '2p':
    title: 'Select 2 Player Mode'
    options: [
      { text: 'Classic', modify: { mode: 'classic' }, img: '2p_classic', menu: '>2p_classic' }
      { text: 'Time Attack', modify: { mode: 'time' }, img: '2p_time', menu: '>2p_time' }
      { text: 'Survival', modify: { mode: 'survival' }, img: '2p_survival', menu: '>2p_survival' }
      { text: 'Back', img: 'title', go: 'back' }
    ]

  '1p_classic':
    title: '1 Player Classic'
    options: [
      { text: 'Start!', img: '1p_classic', action: 'startgame' }
      { text: 'Select Map', img: '1p_classic', menu: '>mapselect' }
      { text: 'Change Speed', img: '1p_classic', menu: '>speed' }
      { text: 'Back', img: '1p_classic', go: 'back' }
    ]

  '2p_classic':
    title: '2 Player Classic'
    options: [
      { text: 'Start!', img: '2p_classic', action: 'startgame' }
      { text: 'Select Map', img: '2p_classic', menu: '>mapselect' }
      { text: 'Change Speed', img: '2p_classic', menu: '>speed' }
      { text: 'Back', img: '2p_classic', go: 'back' }
    ]

  '1p_time':
    title: '1 Player Time Attack'
    options: [
      { text: 'Start!', img: '1p_time', action: 'startgame' }
      { text: 'Select Map', img: '1p_time', menu: '>mapselect' }
      { text: 'Change Speed', img: '1p_time', menu: '>speed' }
      { text: 'Back', img: '1p_time', go: 'back' }
    ]

  '2p_time':
    title: '2 Player Time Attack'
    options: [
      { text: 'Start!', img: '2p_time', action: 'startgame' }
      { text: 'Select Map', img: '2p_time', menu: '>mapselect' }
      { text: 'Change Speed', img: '2p_time', menu: '>speed' }
      { text: 'Back', img: '2p_time', go: 'back' }
    ]

  '2p_survival':
    title: '2 Player Survival'
    options: [
      { text: 'Start!', img: '2p_survival', action: 'startgame' }
      { text: 'Select Map', img: '2p_survival', menu: '>mapselect' }
      { text: 'Change Speed', img: '2p_survival', menu: '>speed' }
      { text: 'Back', img: '2p_survival', go: 'back' }
    ]

  speed:
    title: 'Change Speed'
    initialSelection: (data) ->
      if !data then 0
      else if data.speed == 'boa' then 0
      else if data.speed == 'cobra' then 1
      else if data.speed == 'mamba' then 2
      else 0
    options: [
      { text: 'Boa Constrictor', img: 'speed', modify: { speed: 'boa' }, go: 'back' }
      { text: 'King Cobra', img: 'speed', modify: { speed: 'cobra' }, go: 'back' }
      { text: 'Black Mamba', img: 'speed', modify: { speed: 'mamba' }, go: 'back' }
    ]

  mapselect:
    title: 'Change Map'
    initialSelection: (data) ->
      if !data then 0
      else if data.map == 'warp' then 0
      else if data.map == 'walled' then 1
      else if data.map == 'obstacles' then 2
      else 0
    options: [
      { text: 'Warp', img: 'map_warp', modify: { map: 'warp' }, go: 'back' }
      { text: 'Walled', img: 'map_walled', modify: { map: 'walled' }, go: 'back' }
      { text: 'Obstacles', img: 'map_obstacles', modify: { map: 'obstacles' }, go: 'back' }
    ]

class Menu
  constructor: (@menu, data) ->
    if @menu.initialSelection
      @currentSelection = @menu.initialSelection(data)
    else
      @currentSelection = 0

  selected: =>
    @menu.options[@currentSelection]

  up: =>
    @currentSelection -= 1
    @currentSelection = @menu.options.length - 1 if @currentSelection < 0

  down: =>
    @currentSelection += 1
    @currentSelection = 0 if @currentSelection >= @menu.options.length

class MainMenuController
  constructor: (@app) ->
    new SoundController(@app)

    @data =
      players: 1
      mode: 'classic'
      map: 'warp'
      speed: 'cobra'

    @model = new Menu(Menus.main, @data)
    @view  = new MainMenuView(this, @app.stage)
    @stack = []
    @view.show =>
      @app.sound.playMusic('chipho')
      @setupKeyHandlers()
      @view.showImage(@model.selected().img)
      @view.transitionToMenu @model.menu, 'next'

  run: =>

  setupKeyHandlers: =>
    $(document).on 'keydown', @handleKey

  removeKeyHandlers: =>
    $(document).off 'keydown', @handleKey

  handleKey: (evt) =>
    if evt.keyCode == 38
      @app.sound.playSound('beep')
      @model.up()
      @view.showImage(@model.selected().img)
      @view.setSelection(@model.currentSelection)
    else if evt.keyCode == 40
      @app.sound.playSound('beep')
      @model.down()
      @view.showImage(@model.selected().img)
      @view.setSelection(@model.currentSelection)
    else if evt.keyCode == 13
      @app.sound.playSound('next')
      @processAction @model.selected()
      @view.showImage(@model.selected().img)
    else if evt.keyCode == 27
      @app.sound.playSound('next')
      @popMenu()
      @view.showImage(@model.selected().img)

  processAction: (action) =>
    if action.modify
      for key, value of action.modify
        @data[key] = value

    if action.action
      this["action_" + action.action]()

    if action.menu
      dirCode = action.menu[0]
      nextMenu = action.menu[1...action.menu.length]
      dir = if dirCode == '>' then 'next' else 'back'

      @stack.push(@model)
      @model = new Menu(Menus[nextMenu], @data)
      @changeMenu(@model.menu, dir)
    else if action.go == 'back'
      @popMenu()

  popMenu: =>
    return unless @stack.length
    @model = @stack.pop()
    @changeMenu(@model.menu, 'back')

  changeMenu: (menu, direction = null) =>
    @view.transitionToMenu menu, direction
    @view.setSelection(@model.currentSelection)

  action_showscores: =>
    # console.log "Show da high scores man!"

  action_startgame: =>
    @removeKeyHandlers()
    @app.sound.playSound('next')
    @app.sound.fadeBg()
    @view.remove =>
      @view = null
      @model = null
      @app.controller = new GameController(@app, @data)
      @app.controller.run()

class MainMenuView extends View
  initialize: =>
    @title = null
    @submenu = null
    @container.alpha = 0
    @stage.addChild(@container)

  showImage: (name) =>
    return if @title && @title._name == name

    oldTitle = @title
    if !name
      @title = null
      @_removeOldImage oldTitle
      return

    newTitle = createTitlePortion(name)
    newTitle._name = name
    newTitle.alpha = 0
    newTitle.regX = 0.5
    newTitle.regY = 0.5
    @title = newTitle
    @container.addChild @title

    if oldTitle
      @_removeOldImage oldTitle
      @_showNewImage()
    else
      @_showNewImage()

  _removeOldImage: (oldTitle, callback = ->) =>
    createjs.Tween.get(oldTitle, override: true)
      .to(alpha: 0, 200, createjs.Ease.sineInOut)
      .call =>
        @container.removeChild oldTitle
        callback()

  _showNewImage: =>
    createjs.Tween.get(@title, override: true)
      .to(alpha: 1, 200, createjs.Ease.sineInOut)

  transitionToMenu: (menu, direction, callback = ->) =>
    newSubmenu = new Submenu(menu)
    newSubmenu.x = 450 - newSubmenu.maxTextWidth / 2
    newSubmenu.y = 350

    lastSubmenu = @submenu
    @submenu = newSubmenu

    if direction == 'next'
      newSubmenu.x = 910
    else if direction == 'back'
      newSubmenu.x = -10 - newSubmenu.maxTextWidth

    @container.addChild newSubmenu

    if direction == 'next'
      if lastSubmenu
        createjs.Tween.get(lastSubmenu, override: true)
          .to(x: -10 - lastSubmenu.maxTextWidth, 300, createjs.Ease.quartOut)
          .call => @container.removeChild lastSubmenu
    else if direction == 'back'
      if lastSubmenu
        createjs.Tween.get(lastSubmenu, override: true)
          .to(x: 910, 300, createjs.Ease.quartOut)
          .call => @container.removeChild lastSubmenu
    else
      @container.removeChild @submenu if @submenu?

    if direction
      createjs.Tween.get(newSubmenu, override: true)
        .to(x: 450 - newSubmenu.maxTextWidth / 2, 400, createjs.Ease.getBackOut(2))
        .call(callback)
    else
      callback()

  show: (callback = ->) =>
    createjs.Tween.get(@container)
      .to(alpha: 1, 500)
      .call(callback)

  remove: (callback) =>
    createjs.Tween.get(@container)
      .to(alpha: 0, 500).call =>
        @stage.removeChild @container
        callback()

  setSelection: (idx) =>
    @submenu.setSelection(idx)
