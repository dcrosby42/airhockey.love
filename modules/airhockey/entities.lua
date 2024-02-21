local Debug = require("mydebug").sub("AirHockey", true, true)
local Estore = require "castle.ecs.estore"
local inspect = require "inspect"

local PUCK_RADIUS = 40
local MALLET_RADIUS = 60

local E = {}


function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  E.physicsWorld(estore, res)
  E.background(estore, res)

  E.add_walls(estore, res)

  -- E.puck(estore, res, 150, 150, { color = "blue" })
  E.puck(estore, res, 450, 650, { color = "red" })

  E.mallet(estore, res, w / 2, h - 75, { color = "blue" })
  E.mallet(estore, res, w / 2, 75, { color = "blue" })

  E.buttons(estore, res)

  return estore
end

function E.physicsWorld(estore, res)
  return estore:newEntity({
    { 'physicsWorld', { allowSleep = false } }, -- no gravity
  })
end

function E.background(estore, res)
  local pic_id = "rink1"
  local imgW = res.pics[pic_id].rect.w
  local scale = res.data.screen_size.width / imgW
  return estore:newEntity({
    { 'pos' },
    { 'pic', { id = pic_id, sx = scale, sy = scale } }

  })
end

local function staticBox(x, y, w, h, opts)
  opts = opts or {}
  return {
    { 'tag',            { name = opts.tag or 'block' } },
    { 'body',           { dynamic = false } },
    { 'rectangleShape', { w = w, h = h } },
    { 'pos',            { x = x, y = y } },
  }
end

function E.add_walls(parent, res)
  local sw, sh = res.data.screen_size.width, res.data.screen_size.height
  local midx = sw / 2
  local midy = sh / 2
  local bottom = sh
  local top = 0
  local left = 0
  local right = sw
  local thick = 10

  do
    local x = midx
    local y = top
    local w = sw
    local h = thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_wall", tag = "wall" }))
    e.body.debugDraw = true
  end
  do
    local x = midx
    local y = bottom
    local w = sw
    local h = thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_wall", tag = "wall" }))
    e.body.debugDraw = true
  end
  do
    local x = left
    local y = midy
    local w = thick
    local h = sh - thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "left_wall", tag = "wall" }))
    e.body.debugDraw = true
  end
  do
    local x = right
    local y = midy
    local w = thick
    local h = sh - thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "right_wall", tag = "wall" }))
    e.body.debugDraw = true
  end
end

function E.puck(parent, res, x, y, opts)
  opts = opts or {}
  opts.color = opts.color or "blue"
  local pic_id = "puck_" .. opts.color
  opts.name = opts.name or pic_id

  local imgSize = res.pics[pic_id].rect.w
  local ratio = PUCK_RADIUS / (imgSize / 2)
  local puck = parent:newEntity({
    { 'name', { name = opts.name } },
    { 'tag',  { name = 'puck' } },
    { 'pic',  { id = pic_id, sx = ratio, sy = ratio, centerx = 0.5, centery = 0.5 } },
    { 'pos',  { x = x, y = y } },
    -- { 'vel',  { dx = 400, dy = 230 } },
    { 'vel',  { dx = 0, dy = 0 } },
    { 'body', {
      mass = 1,
      friction = 0.0,
      restitution = 0.9,
      debugDraw = false,
    } },
    { 'force',       {} },
    { 'circleShape', { radius = PUCK_RADIUS } },

    -- { 'sound',       { sound = "hit1", volume = 1 } },
    { 'sound',       { sound = "drop_puck1", volume = 1 } },
  })
end

function E.mallet(parent, res, x, y, opts)
  opts = opts or {}
  opts.color = opts.color or "blue"
  local pic_id = "mallet_" .. opts.color
  opts.name = opts.name or pic_id

  local imgSize = res.pics[pic_id].rect.w
  local scale = MALLET_RADIUS / (imgSize / 2)
  scale = scale * 1.05 -- mallet image is a little squished, so inflate the scale a bit
  local mallet = parent:newEntity({
    { 'name',      { name = opts.name } },
    { 'tag',       { name = "mallet" } },
    { 'touchable', { radius = MALLET_RADIUS * 1.20 } },
    { 'pic',       { id = pic_id, sx = scale, sy = scale, centerx = 0.5, centery = 0.5 } },
    { 'pos',       { x = x, y = y } },
    { 'vel',       { dx = 0, dy = 0 } },
    { 'body', {
      mass = 1,
      friction = 0.0,
      restitution = 0.9,
      debugDraw = false,
    } },
    { 'force',       {} },
    { 'circleShape', { radius = MALLET_RADIUS } },
  })
end

function E.buttons(parent, res)
  local w, h = love.graphics.getDimensions()
  do
    local x, y = w - 44, 50
    parent:newEntity({
      { 'name',   { name = "power_button" } },
      { 'pic',    { id = 'power_button', sx = 0.25, sy = 0.25, centerx = 0.5, centery = 0.5, color = { 1, 1, 1, 0.2 } } },
      { 'pos',    { x = x, y = y } },
      { 'button', { kind = 'hold', eventtype = 'castle.reloadRootModule', holdtime = 0.5, radius = 40 } },
    })
  end
  do
    local x, y = w - 44, h - 50
    parent:newEntity({
      { 'name',   { name = "debug_button" } },
      { 'pic',    { id = 'debug_button', sx = 0.7, sy = 0.7, centerx = 0.5, centery = 0.5, color = { 1, 1, 1, 0.75 } } },
      { 'pos',    { x = x, y = y } },
      { 'button', { kind = 'hold', eventtype = 'castle.toggleDebugLog', holdtime = 0.4, radius = 40 } },
    })
  end
end

return E
