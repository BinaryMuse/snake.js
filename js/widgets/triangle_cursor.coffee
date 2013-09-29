class TriangleCursor extends createjs.Container
  constructor: ->
    @initialize()

  initialize: =>
    super

    triangle1 = new createjs.Shape()
    triangle1.graphics.beginFill('black').beginStroke('black')
      .moveTo(0, 3).lineTo(20, 10).lineTo(0, 17).lineTo(0, 3)

    triangle2 = new createjs.Shape()
    triangle2.graphics.beginFill('white').beginStroke('black')
      .moveTo(0, 3).lineTo(20, 10).lineTo(0, 17).lineTo(0, 3)

    triangle1.regY = triangle2.regY = 10
    triangle1.y = triangle2.y = 10
    triangle2.scaleY = 0.0

    tt1 = createjs.Tween.get(triangle1, paused: true)
      .to(scaleY: 0.0, skewX: -20, 750, createjs.Ease.quadIn)
      .wait(1500)
      .to(scaleY: 0.0, skewX: 30, 0)
      .to(scaleY: 1.0, skewX: 0, 750, createjs.Ease.quadOut)

    tt2 = createjs.Tween.get(triangle2, paused: true)
      .wait(750)
      .to(scaleY: 0.0, skewX: 30, 0)
      .to(scaleY: 1.0, skewX: 0, 750, createjs.Ease.quadOut)
      .to(scaleY: 0.0, skewX: -20, 750, createjs.Ease.quadIn)
      .wait(750)

    timeline = new createjs.Timeline([tt1, tt2], {}, loop: true)

    @addChild triangle1
    @addChild triangle2
