local Debug = require("mydebug").sub("AirHockey", true, true)
local Estore = require "castle.ecs.estore"
local inspect = require "inspect"

local PUCK_RADIUS = 40
local MALLET_RADIUS = 60
local GOAL_WIDTH = 250
local GOAL_DEPTH = 90

local SHOW_RELOAD_BUTTON = true
local SHOW_DEBUG_TOGGLE_BUTTON = false

local DEBUG_DRAW = false
local DEBUG_ZOOMOUT = DEBUG_DRAW
local DEBUG_DRAW_WALLS = DEBUG_DRAW
local DEBUG_HIDE_BACKGROUND = DEBUG_DRAW
local DEBUG_MALLET_IMG = DEBUG_DRAW
local DEBUG_MALLET_BODY = DEBUG_DRAW
local DEBUG_PUCK_IMG = DEBUG_DRAW
local DEBUG_PUCK_BODY = DEBUG_DRAW

local DEBUG_ZOOMOUT = false
-- local DEBUG_HIDE_BACKGROUND = false

local E = {}


function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  -- E.airhockeyGame(estore, res)
  E.testEndGame(estore, res)

  return estore
end

function E.airhockeyGame(estore, res)
  E.game_state(estore, res)

  E.dev_state(estore, res)

  local viewport = E.viewport(estore, res)

  local gameTable = E.gameTable(viewport, res)

  E.physicsWorld(gameTable, res)

  E.background(gameTable, res)

  E.add_walls(gameTable, res)

  E.scoreBoard(gameTable, res)
  E.malletResetButton_p1(gameTable, res)
  E.malletResetButton_p2(gameTable, res)
  E.puckResetButton(gameTable, res)

  E.puck_drop(gameTable, res, { drift = false })

  E.mallet_p1(gameTable, res)
  E.mallet_p2(gameTable, res)

  E.camera(gameTable, res, "camera1")
  viewport.viewport.camera = "camera1"


  if SHOW_RELOAD_BUTTON then
    E.addReloadButton(estore, res)
  end
  -- if SHOW_DEBUG_TOGGLE_BUTTON then
  --   E.addDebugButton(estore, res)
  -- end
end

function E.viewport(parent, res)
  local w, h = res.data.screen_size.width, res.data.screen_size.height
  return parent:newEntity({
    { 'name',     { name = 'viewport' } },
    { 'viewport', { camera = "" } },
    { 'tr',       {} },
    { 'box',      { w = w, h = h, debug = true } }
  })
end

function E.camera(parent, res, name)
  local w, h
  if parent.box then
    w, h = parent.box.w, parent.box.h
  else
    w, h = love.graphics.getDimensions()
  end
  parent:newEntity({
    { 'name', { name = name } },
    { 'tr',   { x = w / 2, y = h / 2 } }
  })
end

function E.gameTable(parent, res)
  -- local w, h = love.graphics.getDimensions()
  local w, h
  if parent.box then
    w, h = parent.box.w, parent.box.h
  else
    w, h = love.graphics.getDimensions()
  end
  return parent:newEntity({
    { 'name', { name = "table" } },
    { 'box',  { w = w, h = h } },
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
  local scrw = res.data.screen_size.width
  local scrh = res.data.screen_size.height
  local imgW, imgH = res.pics[pic_id].rect.w, res.pics[pic_id].rect.h
  local sx, sy = scrw / imgW, scrh / imgH
  estore:newEntity({
    { 'name', { name = "background" } },
    { 'pic',  { id = pic_id, sx = sx, sy = sy } },
    -- { 'sound', { sound = "city", loop = true } },
    -- { 'sound', { sound = "enterprise", loop = true, } },
  })

  estore:newEntity({
    { 'rect', { x = 0, y = 0, w = scrw, h = scrh, color = { 0, 1, 0 } } }
  })
end

local function staticBox(x, y, w, h, opts)
  opts = opts or {}
  local comps = {
    { 'tag',            { name = opts.tag or 'block' } },
    { 'body',           { dynamic = false, debugDraw = DEBUG_DRAW_WALLS } },
    { 'rectangleShape', { w = w, h = h } },
    { 'tr',             { x = x, y = y } },
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
  local thick = 100


  do
    -- top left
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = w / 2
    local y = top - (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_left_wall", tag = "wall" }))
  end
  do
    -- top right
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = sw - (w / 2)
    local y = top - (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_right_wall", tag = "wall" }))
  end
  do
    -- top goal net
    local w = GOAL_WIDTH
    local h = thick
    local x = sw / 2
    local y = top - GOAL_DEPTH - (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "top_goal", tag = "wall" }))
    e:newComp('tag', { name = "goal" })
    e:newComp('state', { name = "winner", value = "Player2" })
  end
  do
    -- bottom left
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = w / 2
    local y = bottom + (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_left_wall", tag = "wall" }))
  end
  do
    -- bottom right
    local w = sw / 2 - (GOAL_WIDTH / 2)
    local h = thick
    local x = sw - (w / 2)
    local y = bottom + (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_right_wall", tag = "wall" }))
  end
  do
    -- bottom goal net
    local w = GOAL_WIDTH
    local h = thick
    local x = sw / 2
    local y = bottom + GOAL_DEPTH + (thick / 2)
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "bottom_goal", tag = "wall" }))
    e:newComp('tag', { name = "goal" })
    e:newComp('state', { name = "winner", value = "Player1" })
  end
  -- left
  do
    local x = left - (thick / 2)
    local y = midy
    local w = thick
    local h = sh -- - thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "left_wall", tag = "wall" }))
  end
  -- right
  do
    local x = right + (thick / 2)
    local y = midy
    local w = thick
    local h = sh --- thick
    local e = parent:newEntity(staticBox(x, y, w, h, { name = "right_wall", tag = "wall" }))
  end
end

function E.puck(parent, res, x, y, opts)
  opts = opts or {}
  opts.color = opts.color or "blue"
  local pic_id = "puck_" .. opts.color
  opts.name = opts.name or "puck"

  local imgSize = res.pics[pic_id].rect.w
  local ratio = PUCK_RADIUS / (imgSize / 2)
  local r = math.pi / 4
  local puck = parent:newEntity({
    { 'name', { name = opts.name } },
    { 'tag',  { name = 'puck' } },

    { 'tr',   { x = x, y = y } },
    { 'pic',  { r = r, id = pic_id, sx = ratio, sy = ratio, cx = 0.5, cy = 0.5, debug = DEBUG_PUCK_IMG } },
    { 'vel',  { dx = 0, dy = 0 } },

    { 'body', {
      mass = 1,
      friction = 0.0,
      restitution = 0.9,
      debugDraw = DEBUG_PUCK_BODY,
    } },
    { 'force',       {} },
    { 'circleShape', { radius = PUCK_RADIUS } },

    { 'sound',       { sound = "drop_puck1", volume = 1 } },
  })
  return puck
end

-- Place a new puck mid table.
-- opts.drift (bool,true): add a bit of random drift.
function E.puck_drop(parent, res, opts)
  opts = opts or {}
  local w, h = parent.box.w, parent.box.h
  local puck = E.puck(parent, res, w / 2, (h / 2), { color = "red" })

  if opts.drift == nil or opts.drift == true then
    local driftSpeed = 30
    local dir = math.random() * (2 * math.pi)
    puck.vel.dx = math.cos(dir) * driftSpeed
    puck.vel.dy = math.sin(dir) * driftSpeed
  end
  return puck
end

function E.puckResetButton(parent, res)
  local w, h = parent.box.w, parent.box.h
  do
    local x, y = w / 2, h / 2
    parent:newEntity({
      { 'name', { name = "puck_reset" } },
      { 'tr',   { x = x, y = y } },
      { 'button', {
        kind = 'hold',
        eventtype = "puck_reset",
        eventstate = "center",
        holdtime = 1.5,
        progresssize = 32,
      } },
      { 'touchable', { r = 40 } },
    })
  end
end

function E.mallet_p1(parent, res)
  local w = parent.box.w
  return E.mallet(parent, res, w / 2, 75, { name = "mallet_p1", color = "blue", inverted = true })
end

function E.mallet_p2(parent, res)
  local w, h = parent.box.w, parent.box.h
  return E.mallet(parent, res, w / 2, h - 75, { name = "mallet_p2", color = "blue" })
end

function E.mallet(parent, res, x, y, opts)
  opts = opts or {}
  opts.color = opts.color or "blue"
  local pic_id = "mallet_" .. opts.color
  opts.name = opts.name or pic_id

  local imgSize = res.pics[pic_id].rect.w
  local scale = MALLET_RADIUS / (imgSize / 2)
  scale = scale * 1.05 -- mallet image is a little squished, so inflate the scale a bit
  local rot = 0
  if opts.inverted then
    rot = math.pi
  end
  local mallet = parent:newEntity({
    { 'name',      { name = opts.name } },
    { 'tag',       { name = "mallet" } },
    { 'touchable', { r = MALLET_RADIUS * 1.20 } },
    { 'pic',       { id = pic_id, sx = scale, sy = scale, cx = 0.5, cy = 0.5, r = rot, debug = DEBUG_MALLET_IMG } },
    { 'tr',        { x = x, y = y } },
    { 'vel',       { dx = 0, dy = 0 } },
    { 'body', {
      mass = 1,
      friction = 0.0,
      restitution = 0.9,
      debugDraw = DEBUG_MALLET_BODY,
    } },
    { 'force',       {} },
    { 'circleShape', { radius = MALLET_RADIUS } },
  })
  return mallet
end

function E.mallet_reset_button(parent, res, opts)
  opts = opts or {}
  local r = 0
  if opts.inverted then
    r = math.pi
  end
  if not opts.player then
    error("opts.player required. eg 'p1'")
  end
  if not (opts.x and opts.y) then
    error("opts.x and opts.y required")
  end

  parent:newEntity({
    { 'name', { name = "mallet_reset_" .. opts.player } }, -- eg "p1"
    { 'tr',   { x = opts.x, y = opts.y, r = r } },
    { 'button', {
      kind = 'hold',
      eventtype = "mallet_reset",
      eventstate = opts.player, -- eg "p1"
      holdtime = 0.5,
      progresssize = 32,
    } },
    { 'touchable', { r = 40 } },
    { 'pic', {
      id = 'mallet_icon',
      sx = 0.6,
      sy = 0.6,
      cx = 0.5,
      cy = 0.5,
      color = { 1, 1, 1, 0.4 }
    } },
  })
end

function E.malletResetButton_p1(parent, res)
  E.mallet_reset_button(parent, res, { player = "p1", x = 44, y = 50, inverted = true })
end

function E.malletResetButton_p2(parent, res)
  local w, h = parent.box.w, parent.box.h
  E.mallet_reset_button(parent, res, { player = "p2", x = w - 44, y = h - 50 })
end

function E.addReloadButton(parent, res)
  -- (use screen dimensions since this button is "screen" and not "world")
  local w, _ = love.graphics.getDimensions()
  do
    local x, y = w - 44, 50
    parent:newEntity({
      { 'name', { name = "power_button" } },
      { 'tr',   { x = x, y = y } },
      { 'button', {
        kind = 'hold',
        eventtype = 'castle.reloadRootModule',
        holdtime = 0.5,
        progresssize = 32,
      } },
      { 'touchable', { r = 40 } },
      { 'pic', {
        id = 'power_button',
        sx = 0.25,
        sy = 0.25,
        cx = 0.5,
        cy = 0.5,
        color = { 1, 1, 1, 0.2 }
      } },
    })
  end
end

function E.scoreBoard(parent, res)
  local w, h = parent.box.w, parent.box.h

  local scoreLabelComps = {
    { 'name',  {} },
    { 'state', { name = "score", value = 0 } },
    { 'tr',    {} },
    {
      'label',
      {
        text = "00",
        color = { 1, 1, 1, 0.35 },
        w = 90,
        h = 70,
        cx = 0.5,
        cy = 0.5,
        align = "center",
        valign = "center",
        font = 'alarm_clock_medium',
        debug = false,
      },
    },
  }

  -- P1 Score
  local p1 = parent:newEntity(scoreLabelComps)
  p1.name.name = "score_Player1"
  p1.tr.x = w - 45 - 10
  p1.tr.y = (h / 2) - 35 - 10
  p1.tr.r = math.pi
  p1.label.color = { 0, 0, 1, 0.35 }

  -- P2 Score
  local p2 = parent:newEntity(scoreLabelComps)
  p2.name.name = "score_Player2"
  p2.tr.x = 45 + 5
  p2.tr.y = (h / 2) + 35 + 10
  p2.label.color = { 1, 0, 0, 0.35 }
end

function E.game_state(parent, res)
  return parent:newEntity({
    { 'name',  { name = 'game_state' } },
    { 'state', { name = 'Player1', value = 0 } },
    { 'state', { name = 'Player2', value = 0 } },
  })
end

function E.dev_state(parent, res)
  parent:newEntity({
    { 'name',     { name = 'dev_state' } },
    { 'state',    { name = 'debug_draw', value = false } },
    { 'keystate', {} },
  })
end

function E.testEndGame(estore, res)
  local gameState = E.game_state(estore, res)
  local w = res.data.screen_size.width
  local h = res.data.screen_size.height

  local parent = estore:newEntity({
    { 'box', { w = w, h = h } }
  })
  E.scoreBoard(parent, res)


  local updateScoreBoard = require("modules.airhockey.funcs").updateScoreBoard
  gameState.states.Player1.value = 10
  gameState.states.Player2.value = 7
  updateScoreBoard(estore, gameState)

  estore:newEntity({
    { 'tag', { name = "game_over" } }
  })
end

return E
