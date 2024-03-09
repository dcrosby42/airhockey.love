local Estore = require "castle.ecs.estore"
-- local inspect = require "inspect"

local E = {}
function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  estore:newEntity({
    { 'screen_grid', { spacex = 100, color = { 1, 1, 1, 0.2 } } }
  })

  -- E.transformTestGrids(estore, res)
  E.treeTest(estore, res)

  return estore
end

function E.treeTest(estore, res)
  estore:newEntity({
    { 'tr',  { x = 0, y = 0, r = 0, sx = 1, sy = 1 } },
    { 'img', { img = "tree", debug = true }, }
  })

  estore:newEntity({
    { 'tr',  { x = 200, y = 100, r = 0, sx = 0.8, sy = 0.8 } },
    { 'img', { img = "tree", x = -30, y = -10, debug = true }, }
  })

  estore:newEntity({
    { 'tr',  { x = 300, y = 100, r = 0, sx = 0.8, sy = 0.8 } },
    { 'img', { img = "tree", x = 5, cx = 0.5, cy = 1.0, debug = true }, }
  })
  estore:newEntity({
    { 'tr',  { x = 400, y = 100, r = 0, sx = 1, sy = 1 } },
    -- { 'img', { img = "tree", x = 5, cx = 0.5, cy = 1.0, sx = 0.5, sy = 0.9, debug = true }, }
    { 'img', { img = "tree", sx = 0.75, sy = 0.5, debug = true }, }
  })
  estore:newEntity({
    { 'tr',  { x = 500, y = 100, r = 0, sx = 0.75, sy = 0.5 } },
    -- { 'img', { img = "tree", x = 5, cx = 0.5, cy = 1.0, sx = 0.5, sy = 0.9, debug = true }, }
    { 'img', { img = "tree", debug = true }, }
  })

  estore:newEntity({
    { 'tr',  { x = 100, y = 300, r = 0, sx = 0.8, sy = 0.8 } },
    { 'img', { img = "tree", r = -math.pi / 4, x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'img', { img = "grid_white", } },
    { 'b',   { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } }
  })
  estore:newEntity({
    { 'tr',  { x = 300, y = 300, r = -math.pi / 4, sx = 0.8, sy = 0.8 } },
    { 'img', { img = "tree", x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'img', { img = "grid_white" } },
    { 'b',   { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } }
  })
end

function E.transformTestGrids(estore, res)
  local root = estore:newEntity({
    { 'pos',   { x = 0, y = 0 } },
    { 'scale', { x = 1, y = 1 } },
    { 'rot',   { r = 0 } },
  })
  root:newEntity({
    { 'pic', {
      id = 'grid_white',
      centerx = 0.5,
      centery = 0.5,
    } },
    { 'pos',   { x = 400, y = 500 } },
    { 'scale', { x = 2, y = 1 } },
    { 'rot',   {} },
    -- { 'name',  { name = "grid1" } },
    { 'tag',   { name = "spinme" } },
    { 'state', { name = "spinspeed", value = -math.pi / 4 } },
  })


  -- local pivx, pivy = 100, 100
  local sneak = root:newEntity({
    { 'pos', { x = 100, y = 100 } },
    -- { 'scale', { x = 0.5, y = 0.5 } },
  })
  local pivx, pivy = 900, 500
  local txnode = sneak:newEntity({
    { 'name',   { name = "txnode1" } },
    -- { 'pos',    { x = 100, y = 100 } },
    { 'scale',  { x = 1, y = 1 } },
    { 'rot',    { r = 0.0, aboutx = pivx, abouty = pivy } },
    { 'tag',    { name = "spinme" } },
    { 'state',  { name = "spinspeed", value = math.pi / 30 } },
    { 'timer',  { name = "size", countDown = false } },
    { 'circle', { fill = true, radius = 3, color = { 1, 0, 0 } } },
    { 'circle', { fill = true, radius = 3, offx = pivx, offy = pivy, color = { 0, 1, 0 } } },
  })
  txnode:newEntity({
    { 'screen_grid', { spacex = 100, color = { 0, 1, 0, 0.3 } } }
  })
  txnode:newEntity({
    { 'pic',   { id = 'grid_white' } },
    { 'pos',   { x = 100, y = 200 } },
    { 'scale', { x = 2, y = 1 } },
    { 'rot',   { r = -math.pi / 6 } },
  })
  txnode:newEntity({
    { 'name',  { name = "tree1" } },
    { 'tag',   { name = "spinme" } },
    { 'state', { name = "spinspeed", value = math.pi / 4 } },
    { 'pic', {
      id = 'tree',
      centerx = 0.5,
      centery = 1,
    } },
    { 'pos',   { x = 600, y = 300 } },
    { 'scale', { x = 1, y = 1 } },
    { 'rot',   {} },
  })

  -- local tile2 = root:newEntity({
  --   { 'pic',   { id = 'grid_white' } },
  --   { 'pos',   { x = 100, y = 200 } },
  --   { 'scale', { x = 2, y = 1 } },
  --   { 'rot',   { r = -math.pi / 6 } },
  -- })

  return estore
end

return E
