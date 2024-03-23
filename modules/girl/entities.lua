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
    { 'bgcolor', { color = { 0.5, 0.5, 1.0 } } }
  })

  local parent = estore

  parent:newEntity({
    { 'tr',    { x = 0, y = 0 } },
    { 'anim', {
      name = "catgirl",
      id = "sungirl_stand", -- 620x1000
      x = 200,
      y = 700,
      cx = 0.5,
      cy = 1,
      -- sx = 0.5,
      -- sy = 0.5,
      debug = false,
      timer = "mytimer"
    } },
    { 'timer', { name = "mytimer", countDown = false } }
  })

  return estore
end

return E
