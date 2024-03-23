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
    { 'bgcolor', { color = { 0.2, 0.2, 0.6 } } }
  })

  local parent = estore

  parent:newEntity({
    { 'tr',    { x = 300, y = 700 } },
    { 'anim', {
      name = "catgirl",
      id = "sungirl_run", -- 620x1000
      -- x = -100,
      -- y = -50,
      cx = 0.5,
      cy = 1,
      sx = 0.5,
      sy = 0.5,
      -- r = math.pi / 4,
      debug = true,
      timer = "mytimer"
    } },
    { 'timer', { name = "mytimer", countDown = false } }
  })

  return estore
end

return E
