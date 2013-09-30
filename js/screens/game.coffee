Maps =
  warp:      "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________"
  walled:    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "X____________________________X\n" +
             "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  obstacles: "______________________________\n" +
             "______________________________\n" +
             "__XX______________________XX__\n" +
             "__XX______________________XX__\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________XX______________\n" +
             "______________XX______________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "______________________________\n" +
             "__XX______________________XX__\n" +
             "__XX______________________XX__\n" +
             "______________________________\n" +
             "______________________________"

class Snake
  @UP    = new Vector2(0, -1)
  @DOWN  = new Vector2(0, 1)
  @LEFT  = new Vector2(-1, 0)
  @RIGHT = new Vector2(1, 0)

  constructor: (initialHead, initialDirection, totalLength, @map) ->
    @dead = false
    @growAmount = 0
    @tiles = [initialHead]
    @direction = initialDirection
    @nextDirection = initialDirection

    @height = @map.length
    @width  = @map[0].length

    if totalLength >= 2
      oppositeDir = @direction.reverse()
      for i in [2..totalLength]
        @tiles.push(_.last(@tiles).add(oppositeDir))

  nextHead: =>
    _.first(@tiles).add(@nextDirection)

  grow: (amount) =>
    @growAmount += amount

  move: =>
    return if @dead

    newHead = @nextHead()
    newHead.x = @width - 1  if newHead.x < 0
    newHead.x = 0           if newHead.x >= @width
    newHead.y = @height - 1 if newHead.y < 0
    newHead.y = 0           if newHead.y >= @height

    @tiles.unshift(newHead)
    if @growAmount > 0
      @growAmount--
    else
      @tiles.pop()
    @direction = @nextDirection

  changeDir: (dir) =>
    if dir.equals(Snake.UP)
      @nextDirection = dir unless @direction.equals(Snake.DOWN)
    else if dir.equals(Snake.DOWN)
      @nextDirection = dir unless @direction.equals(Snake.UP)
    else if dir.equals(Snake.LEFT)
      @nextDirection = dir unless @direction.equals(Snake.RIGHT)
    else if dir.equals(Snake.RIGHT)
      @nextDirection = dir unless @direction.equals(Snake.LEFT)

class Game
  constructor: (@options) ->
    window.g = this
    @paused = true
    @tickCallbacks = []
    @food = []

    @map    = Maps[@options.map]
    @mapTiles = @map.split("\n").map((line) -> line.split(""))
    @height   = @mapTiles.length
    @width    = @mapTiles[0].length

    @generateSnakes()

  onTick: (fn) =>
    @tickCallbacks.push(fn)

  pause: =>
    return if @paused
    @paused = true
    clearInterval(@timer) if @timer?

  unpause: =>
    return unless @paused
    @paused = false
    time = switch @options.speed
      when 'boa'   then 300
      when 'cobra' then 150
      when 'mamba' then 80
    @timer = setInterval @_doTick, time
    @_doTickNoMove()

  allTiles: =>
    return @_memoAllTiles if @_memoAllTiles?

    tiles = []
    for x in [0...@width]
      for y in [0...@height]
        tiles.push(new Vector2(x, y))
    @_memoAllTiles = tiles

  occupiedTiles: =>
    @solidTiles().concat(@food)

  unoccupiedTiles: =>
    _.filter(@allTiles(), (t) => !_.any(@occupiedTiles(), t.equals, t))

  solidTiles: =>
    @snakeTiles().concat(@walls())

  snakeTiles: =>
    _.flatten(_.map(@snakes, 'tiles'))

  walls: =>
    return @_memoWalls if @_memoWalls?

    walls = []
    for row, y in @mapTiles
      for col, x in row
        walls.push(new Vector2(x, y)) if col == 'X'
    @_memoWalls = walls

  _doTick: =>
    @tick?()
    cb() for cb in @tickCallbacks

  _doTickNoMove: =>
    @tick?(false)
    cb() for cb in @tickCallbacks

class ClassicGame extends Game
  generateSnakes: =>
    if @options.players == 1
      @snakes = [new Snake(
        new Vector2(0, Math.floor(@height / 2)), new Vector2(1, 0), 3, @mapTiles
      )]
    else if @options.players == 2
      @snakes = [new Snake(
        new Vector2(0, Math.floor(@height / 2)), new Vector2(1, 0), 3, @mapTiles
      ), new Snake(
        new Vector2(@width - 1, Math.floor(@height / 2)),
        new Vector2(-1, 0), 3, @mapTiles
      )]

  generateFood: =>
    return if @food.length > 0

    tiles = @unoccupiedTiles()
    newFoodTile = tiles[Math.floor(Math.random() * tiles.length)]
    @food.push(newFoodTile)

  tick: (move = true) =>
    if move
      for snake in @snakes
        head = snake.nextHead()
        snake.dead = true if _.any(@solidTiles(), head.equals, head)
        snake.move()

    snakeIsEatingFood = (snake) =>
      head = snake.tiles[0]
      _.any(@food, head.equals, head)
    snakesToGrow = _.filter(@snakes, snakeIsEatingFood)
    snake.grow(3) for snake in snakesToGrow

    console.log "A snake is growing!", snakesToGrow if snakesToGrow.length

    allSnakeHeads = _.map(@snakes, (s) -> s.tiles[0])
    @food = _.filter(@food, (f) -> !_.any(allSnakeHeads, f.equals, f))
    @generateFood()

class GameController
  constructor: (@app, @options) ->
    @game = switch @options.mode
      when 'classic' then new ClassicGame(@options)
    @view = new GameView(this, @app.stage)
    @game.onTick =>
      @view.tick()

    console.log @game

  run: =>
    @setupKeyHandlers()
    @app.sound.playMusic('ideetje')
    @game.unpause()

  setupKeyHandlers: =>
    $(document).on 'keydown', @handleKey

  removeKeyHandlers: =>
    $(document).off 'keydown', @handleKey

  handleKey: (evt) =>
    if @game.paused
      @handlePausedKey(evt)
    else
      @handleGameKey(evt)

  handlePausedKey: (evt) =>
    switch evt.keyCode
      when 27 then @unpause()

  handleGameKey: (evt) =>
    switch evt.keyCode
      when 37 then @p1dir(Snake.LEFT)
      when 38 then @p1dir(Snake.UP)
      when 39 then @p1dir(Snake.RIGHT)
      when 40 then @p1dir(Snake.DOWN)
      when 27 then @pause()

  p1dir: (dir) =>
    @game.snakes[0].changeDir(dir)

  pause: =>
    @game.pause()
    @app.sound.bg.pause()
    @app.sound.playSound('pause')
    @view.setPause true, true

  unpause: =>
    @app.sound.playSound('next')
    @view.setPause false, true, =>
      @app.sound.bg.play()
      @game.unpause()

class GameView extends View
  initialize: =>
    @stage.addChild @container
    width  = @controller.game.width
    height = @controller.game.height

    @grid = new GameGrid(@controller.game)
    @grid.regX = width * 20 / 2
    @grid.x = 450
    @grid.y = 0

    @pauseContainer = new createjs.Container()
    @pauseContainer.alpha = 0
    pauseBlock = new createjs.Shape()
    pauseBlock.graphics.beginFill("#fff")#.beginStroke("#fff")
      .drawRect(0, 0, 20 * width, 20 * height)
    @pauseContainer.addChild pauseBlock
    @pauseContainer.regX = width * 20 / 2
    @pauseContainer.x = 450
    @pauseContainer.y = 0

    mask = new createjs.Shape()
    mask.graphics.beginFill("#000").beginStroke("#000")
      .drawRect(0, 0, 20 * width, 20 * height + 0.5)
    @grid.mask = mask
    mask.x = @grid.x - @grid.regX
    mask.y = -0.5
    window.m = mask
    window.t = this

    @container.addChild @grid
    @container.addChild @pauseContainer

  setPause: (paused, transition, callback = ->) =>
    alpha = if paused then 1 else 0

    if transition
      createjs.Tween.get(@pauseContainer)
        .to(alpha: alpha, 300)
        .call(callback)
    else
      @pauseContainer.alpha = alpha
      callback()

  tick: =>
    @grid.redrawSnakes()
    @grid.redrawFood()
