local Debug = require("mydebug").sub("AirHockey", true, true)
local Estore = require "castle.ecs.estore"
local inspect = require "inspect"

local PUCK_RADIUS = 40
local MALLET_RADIUS = 60
local GOAL_WIDTH = 250
local GOAL_DEPTH = 90

local SHOW_RELOAD_BUTTON = true
local SHOW_DEBUG_TOGGLE_BUTTON = false
local DEBUG_ZOOMOUT = false
local DEBUG_DRAW_WALLS = DEBUG_ZOOMOUT
local DEBUG_HIDE_BACKGROUND = DEBUG_ZOOMOUT

-- local DEBUG_DRAW_WALLS = true
-- local DEBUG_HIDE_BACKGROUND = true

local E = {}


function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  E.gameState(estore, res)

  -- local viewport = E.viewport(estore, res)
  -- local parent = viewport
  -- local parent = estore
  local world = estore:newEntity({
    { 'name', { name = 'world' } },
    -- { 'tr',   { x = 50, y = 50, sx = 0.5, sy = 0.5 } }
  })
  local parent = world

  E.physicsWorld(parent, res)

  E.background(parent, res)

  E.add_walls(parent, res)

  -- E.puck(parent, res, w / 2, h - 75, { color = "red" })
  E.puck(parent, res, w / 2, h - 75, { color = "red" })

  E.mallet(parent, res, 450, 650, { color = "blue" })
  E.mallet(parent, res, w / 2, 75, { color = "blue" })

  E.scoreBoard(parent)


  -- if SHOW_RELOAD_BUTTON then
  --   E.addReloadButton(estore, res)
  -- end
  -- if SHOW_DEBUG_TOGGLE_BUTTON then
  --   E.addDebugButton(estore, res)
  -- end

  return estore
end

function E.viewport(estore, res)
  local w, h = love.graphics.getDimensions()
  local scale = 1
  local x, y = 0, 0
  if DEBUG_ZOOMOUT then
    scale = 0.7
    x, y = -100, -100
  end

  return estore:newEntity({
    { 'name',     { name = "viewport" } },
    { 'viewport', { sx = scale, sy = scale } },
    { 'pos',      { x = x, y = y } },
    { 'rect',     { w = w, h = h, offx = 0, offy = 0, draw = false } }
  })
end

function E.physicsWorld(estore, res)
  return estore:newEntity({
    { 'name',         { name = "physics_world" } },
    { 'physicsWorld', { allowSleep = false } }, -- no gravity
  })
end

function E.background(estore, res)
  if DEBUG_HIDE_BACKGROUND then return nil end
  local pic_id = "rink1"
  local imgW, imgH = res.pics[pic_id].rect.w, res.pics[pic_id].rect.h
  local sx = res.data.screen_size.width / imgW
  local sy = res.data.screen_size.height / imgH
  estore:newEntity({
    { 'name', { name = "background" } },
    { 'pos' },
    { 'pic',  { id = pic_id, sx = sx, sy = sy } }
  })
end

local function staticBox(x, y, w, h, opts)
  opts = opts or {}
  local comps = {
    { 'tag',            { name = opts.tag or 'block' } },
    { 'body',           { dynamic = false } },
    { 'rectangleShape', { w = w, h = h } },
    { 'pos',            { x = x, y = y } },
  }
  if opts.name then
    table.insert(comps, { 'name', { name = opts.name } })
  end
  return comps
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
    -- top left
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = w / 2
    local y = top
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_left_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  do
    -- top right
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = sw - (w / 2)
    local y = top
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_right_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  do
    -- top goal net
    local w = GOAL_WIDTH
    local h = thick
    local x = sw / 2
    local y = top - GOAL_DEPTH
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_goal", tag = "wall" }))
    e:newComp('tag', { name = "goal" })
    e:newComp('state', { name = "winner", value = "Player2" })
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  do
    -- bottom left
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = w / 2
    local y = bottom
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_left_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  do
    -- bottom right
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = sw - (w / 2)
    local y = bottom
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_right_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  do
    -- bottom goal net
    local w = GOAL_WIDTH
    local h = thick
    local x = sw / 2
    local y = bottom + GOAL_DEPTH
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_goal", tag = "wall" }))
    e:newComp('tag', { name = "goal" })
    e:newComp('state', { name = "winner", value = "Player1" })
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  -- left
  do
    local x = left
    local y = midy
    local w = thick
    local h = sh - thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "left_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
  end
  -- right
  do
    local x = right
    local y = midy
    local w = thick
    local h = sh - thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "right_wall", tag = "wall" }))
    e.body.debugDraw = DEBUG_DRAW_WALLS
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

    { 'tr',   { x = x, y = y } },
    { 'img',  { img = pic_id, sx = ratio, sy = ratio, cx = 0.5, cy = 0.5 } },
    { 'vel',  { dx = 100, dy = 0 } },

    -- { 'pic',  { id = pic_id, sx = ratio, sy = ratio, centerx = 0.5, centery = 0.5 } },
    -- { 'pos',  { x = x, y = y } },
    -- { 'vel',  { dx = 0, dy = 0 } },
    { 'body', {
      mass = 1,
      friction = 0.0,
      restitution = 0.9,
      debugDraw = false,
    } },
    { 'force',       {} },
    { 'circleShape', { radius = PUCK_RADIUS } },

    { 'sound',       { sound = "drop_puck1", volume = 1 } },
  })
  return puck
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
    { 'img',       { img = pic_id, sx = scale, sy = scale, cx = 0.5, cy = 0.5 } },
    { 'tr',        { x = x, y = y } },
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

function E.addReloadButton(parent, res)
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
end

function E.addDebugButton(parent, res)
  local w, h = love.graphics.getDimensions()
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

function E.scoreBoard(parent)
  local w, h = love.graphics.getDimensions()

  -- P1 Score
  parent:newEntity({
    -- Important name format! Player1 corresponds with goal and game_state
    { 'name',  { name = "score_Player1" } },
    { 'state', { name = "score", value = 0 } },
    { 'tr',    { x = w - 45 - 10, y = (h / 2) - 35 - 10 } },
    {
      'label',
      {
        text = "00",
        color = { 0, 0, 1, 0.35 },
        w = 90,
        h = 70,
        cx = 0.5,
        cy = 0.5,
        r = math.pi,
        align = "center",
        valign = "center",
        font = 'alarm_clock_medium',
        -- debug = true,
      },
    },
  })

  -- P2 Score
  parent:newEntity({
    -- Important name format! Player2 corresponds with goal and game_state
    { 'name',  { name = "score_Player2" } },
    { 'state', { name = "score", value = 0 } },
    -- { 'pos',   { x = 10, y = (h / 2) + 10 } },
    { 'tr',    { x = 45 + 5, y = (h / 2) + 35 + 10 } },
    {
      'label',
      {
        text = "00",
        color = { 1, 0, 0, 0.35 },
        w = 90,
        h = 70,
        cx = 0.5,
        cy = 0.5,
        align = "center",
        valign = "center",
        font = 'alarm_clock_medium',
        -- debug = true,
      },
    },
  })
end

function E.gameState(parent, res)
  parent:newEntity({
    { 'name',  { name = 'game_state' } },
    { 'state', { name = 'Player1', value = 0 } },
    { 'state', { name = 'Player2', value = 0 } },
  })
end

return E
