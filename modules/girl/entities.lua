local Estore = require "castle.ecs.estore"
local inspect = require "inspect"

local function tag(name)
  return { 'tag', { name = name } }
end

local E = {}
function E.initialEntities(res)
  local w, h = love.graphics.getDimensions()
  res:get("data"):put("screen_size", { width = w, height = h })

  local estore = Estore:new()

  estore:newEntity({
    { 'bgcolor', { color = { 0.2, 0.2, 0.4 } } }
  })

  local parent = estore

  parent:newEntity({
    { 'name', { name = "gpic" } },
    { 'tr',   { x = 350, y = 300 } },
    -- { 'pic',  { id = "girl3", sx = 0.25, sy = 0.25, debug = true } },
    { 'pic', {
      id = "girl3",
      sx = 0.3,
      sy = 0.3,
      r = math.pi / -9,
      cx = 0.5,
      cy = 1,
      debug = true
    } },
  })

  parent:newEntity({
    { 'tr',    { x = 300, y = 700, } },
    { 'anim', {
      name = "catgirl",
      id = "sungirl_run", -- 620x1000
      -- x = -100,
      -- y = -50,
      cx = 0.5,
      cy = 1,
      -- sx = 0.5,
      -- sy = 0.5,
      -- r = math.pi / 4,
      debug = true,
      timer = "mytimer"
    } },
    { 'timer', { name = "mytimer", countDown = false } }
  })

  parent:newEntity({
    { 'tr',  { x = 400, y = 100 } },
    { 'pic', { id = "tree", debug = true } },
  })

  return estore
end

return E
