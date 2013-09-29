class Vector2
  # Generate a vector with an x between 0 and maxX - 1 (inclusive)
  # and a y between 0 and maxY - 1 (inclusive).
  @random = (maxX, maxY) ->
    x = Math.floor(Math.random() * maxX)
    y = Math.floor(Math.random() * maxY)
    new Vector2(x, y)

  constructor: (@x, @y) ->

  add: (other) ->
    new Vector2(@x + other.x, @y + other.y)

  equals: (other) ->
    other.x == @x && other.y == @y

  reverse: ->
    new Vector2(@x * -1, @y * -1)
