
canvas = document.querySelector '#canvas'
ctx = canvas.getContext '2d'
ctx.globalAlpha = 1
ctx.lineWidth = 6
ctx.strokeStyle = 'white'
ctx.fillStyle = 'hsl(240,90%,80%)'
ctx.shadowColor = 'hsl(240,30%,40%)'
ctx.shadowBlur = 6
ctx.shadowOffsetX = 0
ctx.shadowOffsetY = 0
ctx.lineCap = 'round'
ctx.lineJoin = 'round'

config =
  level: 11
  size: 2
  padding: 8
  step: 27
  block: 110
  rate: 0.5

draw_grids = ->
  unit =
    length: config.block
    x: 20
    y: 20
    padding: config.padding
    level: config.level
  unit.area = (config.size + 1) * config.step

  for x in [0..unit.level]
    for y in [0..unit.level]
      hints =
        x: (x * unit.length) + unit.x
        y: (y * unit.length) + unit.y
      draw_font hints
      ctx.fillRect unit.x + (x * unit.length) - unit.padding
      , unit.y + (y * unit.length) - unit.padding
      , unit.area + (unit.padding * 2)
      , unit.area + (unit.padding * 2)

draw_font = (opts) ->
  unit =
    length: config.step
    size: config.size
  for x in [0..unit.size]
    for y in [0..unit.size]
      hints =
        x: (x * unit.length) + opts.x
        y: (y * unit.length) + opts.y
      draw_cross hints

draw_cross = (opts) ->
  unit =
    length: config.step

  draw_line [
    x: opts.x, y: opts.y
  ,
    x: (opts.x + unit.length), y: (opts.y + unit.length)
  ]...

  draw_line [
    x: (opts.x + unit.length), y: opts.y
  ,
    x: opts.x, y: (opts.y + unit.length)
  ]...

draw_line = (start, reach) ->
  if Math.random() <= config.rate
    ctx.moveTo start.x, start.y
    ctx.lineTo reach.x, reach.y

do main = ->
  ctx.beginPath()
  draw_grids()
  ctx.stroke()