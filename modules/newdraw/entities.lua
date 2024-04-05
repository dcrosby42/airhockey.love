local Estore = require "castle.ecs.estore"
-- local inspect = require "inspect"

local function tag(name)
  return { 'tag', { name = name } }
end

local E = {}
function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  -- E.treeTestOuter(estore, res)
  -- E.transformTestGrids(estore, res)
  -- E.testLabels(estore, res)
  -- E.testViewport(estore, res)
  E.testFonts(estore, res)

  return estore
end

function E.testViewport(estore, res)
  local w, h = love.graphics.getDimensions()

  estore:newEntity({
    { 'bgcolor', { color = { 0.2, 0, 0 } } },
  })

  local viewport = estore:newEntity({
    { 'name',     { name = "viewport" } },
    { 'viewport', { camera = 'cam1', } },
    -- { 'viewport', { camera = 'cam1', blockout = true, bgcolor = { 0, 0, 0.2 } } },
    { 'keystate', {} },
    { 'tr',       { x = 70, y = 90, r = 0.0 } },
    { 'box',      { w = 640, h = 480, debug = false } },
    -- { 'tr',       {} },
    -- { 'box',      { w = w, h = h } },
  })

  local base = viewport:newEntity({
    { 'name',        { name = "base" } },
    -- { 'tag',  { name = 'panzoom' } },
    { 'tr',          { x = 0, y = 0, r = 0, sx = 1, sy = 1 } },
    { 'screen_grid', { spacex = 100, color = { 1, 1, 1, 0.2 } } }
  })


  estore:newEntity({
    { 'name',   { name = 'blueDot' } },
    { 'tr',     { x = 0, y = 0 } },
    { 'circle', { style = 'fill', r = 5, color = { 0, 0, 1 } } }
  })

  estore:newEntity({
    { 'name',   { name = 'selectbox' } },
    { 'tr',     { x = 0, y = 0 } },
    { 'circle', { style = 'fill', r = 4, color = { 1, 1, 1 } } },
    -- { 'box',     { w = 100, h = 66, cx = 0.5, cy = 0.5, debug = false } },
    { 'rect',   { w = 20, h = 20, cx = 0.5, cy = 0.5, color = { 1, 1, 1 } } },
  })

  E.treeTest(base, res)

  E.debugCamera(base, "cam1", 200, 100)
end

function E.debugCamera(parent, name, x, y)
  local color = { 1, 0.5, 0 }
  return parent:newEntity({
    { 'name',     { name = name } },
    { 'tr',       { x = x, y = y, r = 0, sx = 1, sy = 1 } },
    { 'circle',   { style = "line", r = 10, color = color } },
    { 'label',    { text = name, color = color } },
    { 'keystate', {} },
  })
end

function E.testFonts(estore, res)
  -- local fonts = {
  --   "Adventure",
  --   "Adventure_Outline",
  --   "goingtodogreatthings",
  --   "LuckiestGuy",
  --   "narpassword",
  --   "alarm_clock",
  --   "font",
  -- }
  local fonts = {
    "Adventure_24",
    "Adventure_48",
    "Adventure_64",
    "AdventureOutline_24",
    "AdventureOutline_48",
    "AdventureOutline_64",
    "Lucky_24",
    "Lucky_48",
    "Lucky_64",
    "narpassword_24",
    "narpassword_48",
    "narpassword_64",
  }

  local x, y = 10, 10
  for i, font in ipairs(fonts) do
    -- local text = font
    local text = "WINNER"
    local color = { 1, 1, 1, 1 }
    -- local font = "alarm_clock_small"
    -- local font = "alarm_clock_medium"

    estore:newEntity({
      { 'tr', { x = x, y = y, r = 0, sx = s, sy = s } },
      { 'label', {
        text = text,
        color = color,
        font = font,
        align = "center",
        valign = "center",
        debug = true,
      } },
    })
    y = y + 75
    if i % 9 == 0 then
      x = x + 230
      y = 10
    end
  end
end

function E.testLabels(estore, res)
  estore:newEntity({
    { 'screen_grid', { spacex = 50, color = { 1, 1, 1, 0.2 } } }
  })

  estore:newEntity({
    { 'name', { name = "the_label" } },
    { 'tr',   { x = 50, y = 50, r = 0, sx = 1, sy = 1 } },
    { 'label', {
      text = "12:05",
      color = { 1, 0.5, 0 },
      font = "alarm_clock_small",
      -- font = "alarm_clock_medium",
      x = 150,
      y = 90,
      w = 80,
      h = 30,
      cx = 0.25,
      cy = 0.5,
      r = -0.7,
      align = "center",
      valign = "center",
      shadowcolor = { 0.5, 0.2, 0 },
      shadowx = 2.5,
      shadowy = 2.5,
      debug = true,
      sx = 2,
      sy = 2,
    } },
  })
end

function E.treeTestOuter(estore, res)
  estore:newEntity({
    { 'screen_grid', { spacex = 100, color = { 1, 1, 1, 0.2 } } }
  })

  -- E.transformTestGrids(estore, res)
  local base = estore:newEntity({
    { 'name', { name = "base" } },
    { 'tr',   { x = 0, y = 0, r = 0, sx = 1, sy = 1 } },
  })

  estore:newEntity({
    { 'name',   { name = 'blueDot' } },
    { 'tr',     { x = 0, y = 0 } },
    { 'circle', { style = 'fill', r = 5, color = { 0, 0, 1 } } }
  })

  estore:newEntity({
    { 'name',   { name = 'selectbox' } },
    { 'tr',     { x = 0, y = 0 } },
    { 'circle', { style = 'fill', r = 4, color = { 1, 1, 1 } } },
    -- { 'box',     { w = 100, h = 66, cx = 0.5, cy = 0.5, debug = false } },
    { 'rect',   { w = 20, h = 20, cx = 0.5, cy = 0.5, color = { 1, 1, 1 } } },
  })

  E.treeTest(base, res)
  return base
end

function E.treeTest(parent, res)
  parent:newEntity({
    { 'tr',  { x = 0, y = 0, r = 0, sx = 1, sy = 1 } },
    { 'pic', { id = "tree", debug = true }, }
  })

  parent:newEntity({
    { 'tr',  { x = 200, y = 100, r = 0, sx = 0.8, sy = 0.8 } },
    { 'pic', { id = "tree", x = -30, y = -10, debug = true }, }
  })

  parent:newEntity({
    { 'tr',  { x = 300, y = 100, r = 0, sx = 0.8, sy = 0.8 } },
    { 'pic', { id = "tree", x = 5, cx = 0.5, cy = 1.0, debug = true }, }
  })
  parent:newEntity({
    { 'tr',  { x = 400, y = 100, r = 0, sx = 1, sy = 1 } },
    -- { 'pic', { id = "tree", x = 5, cx = 0.5, cy = 1.0, sx = 0.5, sy = 0.9, debug = true }, }
    { 'pic', { id = "tree", sx = 0.75, sy = 0.5, debug = true }, }
  })
  parent:newEntity({
    { 'tr',  { x = 500, y = 100, r = 0, sx = 0.75, sy = 0.5 } },
    -- { 'pic', { id = "tree", x = 5, cx = 0.5, cy = 1.0, sx = 0.5, sy = 0.9, debug = true }, }
    { 'pic', { id = "tree", debug = true }, }
  })

  parent:newEntity({
    { 'tr',  { x = 100, y = 300, r = 0, sx = 0.8, sy = 0.8 } },
    { 'pic', { id = "tree", r = -math.pi / 4, x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'pic', { id = "grid_white", } },
    { 'box', { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } }
  })
  parent:newEntity({
    { 'tr',  { x = 300, y = 300, r = 0, sx = 1.2, sy = 0.8 } },
    { 'pic', { id = "tree", r = -math.pi / 4, x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'pic', { id = "grid_white", } },
    { 'box', { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } },
    tag("clickable"),
    { 'tag', }
  })
  local findme = parent:newEntity({
    { 'tr',    { x = 500, y = 300, r = -math.pi / 4, sx = 0.8, sy = 0.8 } },
    { 'pic',   { id = "tree", x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'pic',   { id = "grid_white" } },
    { 'box',   { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } },
    { 'name',  { name = "findme" } },
    { 'tag',   { name = "spinme" } },
    { 'state', { name = "spinspeed", value = 0.7 } },
    tag("clickable"),
  })
  findme:newEntity({
    { 'name',   { name = 'greenDot' } },
    { 'tr',     { x = 0, y = 0 } },
    { 'circle', { style = 'fill', r = 5, color = { 0, 1, 0 } } }
  })



  parent:newEntity({
    { 'tr',  { x = 700, y = 300, r = -math.pi / 4, sx = 1.5, sy = 0.6 } },
    { 'pic', { id = "tree", x = 5, cx = 0.5, cy = 1.0, debug = true } },
    { 'pic', { id = "grid_white" } },
    { 'box', { w = 50, h = 100, cx = 0.5, cy = 0.75, debug = true } },
    tag("clickable"),
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
