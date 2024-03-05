local Estore = require "castle.ecs.estore"
-- local inspect = require "inspect"

local E = {
  initialEntities = function(res)
    local w, h = love.graphics.getDimensions()
    res:get("data"):put("screen_size", { width = w, height = h })

    local estore = Estore:new()

    -- estore:newEntity({
    -- { 'bgcolor', { color = { 0, 0, 0.4 } } }
    -- { 'bgcolor', {} },
    -- })

    estore:newEntity({
      { 'screen_grid', { spacex = 100, color = { 1, 1, 1, 0.15 } } }
    })

    local root = estore:newEntity({
      { 'pos',   { x = 0, y = 0 } },
      { 'scale', { x = 1.3, y = 1.3 } },
      { 'rot',   { r = 0 } },
    })

    root:newEntity({
      { 'screen_grid', { spacex = 100, color = { 0, 1, 0, 0.3 } } }
    })

    local tile = root:newEntity({
      { 'pic',   { id = 'grid_white' } },
      { 'pos',   { x = 100, y = 200 } },
      { 'scale', { x = 2, y = 1 } },
      { 'rot',   { r = -math.pi / 6 } },
    })

    return estore
  end,
}

return E
