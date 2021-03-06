class GameGrid extends createjs.Container
  constructor: (@game) ->
    @height = @game.mapTiles.length
    @width  = @game.mapTiles[0].length
    @initialize()

  initialize: =>
    super
    @snakeContainers = @game.snakes.map(=> new createjs.Container())
    @foodContainer = new createjs.Container()

    # n = new createjs.Shape()
    # n.graphics.beginFill('red').beginStroke('red')
    #   .drawRect(0, 0, 1000, 1000)
    # @addChild n

    for row, i in @game.mapTiles
      for col, j in row
        square = new createjs.Shape()
        graphics = square.graphics
        if col == 'X'
          graphics.beginStroke("#000").beginFill("#000")
        else
          graphics.beginStroke("#ccc")
        graphics.drawRect(20 * j, 20 * i, 20, 20)
        @addChild square

    @border = new createjs.Shape()
    @border.graphics.beginStroke("#000")
      .drawRect(0, 0, 20 * @width, 20 * @height)

    for cont in @snakeContainers
      @addChild cont

    @addChild @foodContainer
    @addChild @border

  redrawSnakes: =>
    snakes = @game.snakes
    snakesAndContainers = _.zip(snakes, @snakeContainers)
    for [snake, cont] in snakesAndContainers
      cont.removeAllChildren()
      for tile in snake.tiles
        square = new createjs.Shape()
        square.graphics.beginFill("green").beginStroke("green")
          .drawRect(0, 0, 20, 20)
        square.x = tile.x * 20
        square.y = tile.y * 20
        cont.addChild square

  redrawFood: =>
    @foodContainer.removeAllChildren()
    for food in @game.food
      square = new createjs.Shape()
      square.graphics.beginFill('red').beginStroke('red')
        .drawRect(0, 0, 20, 20)
      square.x = food.x * 20
      square.y = food.y * 20
      @foodContainer.addChild square
