local EventHelpers = require "castle.systems.eventhelpers"
-- local Entities     = require "modules.newdraw.entities"
local inspect = require "inspect"

local function bounds2rect(b)
  local w, h = b.w, b.h
  local ox = b.cx * w
  local oy = b.cy * h
  local x, y = b.x - ox, b.y - oy
  return x, y, x + w, y + w
end

-- local function collectEntityTrs(e)
-- end


local function calcBounds(e)
  if not e.b then
    error("calcBounds needs an entity with a 'b' component")
  end
  local x1, y1, x2, y2 = bounds2rect(e.b)
  -- print("bounds2rect: " .. inspect({ x1, y1, x2, y2 }))
  local t = calcTransform(e)
  if t then
    local tx1, ty1 = t:transformPoint(x1, y1)
    local tx2, ty2 = t:transformPoint(x2, y2)
    return tx1, ty1, tx2, ty2
  else
    return x1, y1, x2, y2
  end
end


return function(estore, input, res)
  -- estore:seekEntity(hasName('txnode1'), function(e)
  --   local node = e:getParent()
  --   local s = 1 + (math.sin(e.timers.size.t) / 4)
  --   node.scale.x = s
  --   node.scale.y = s
  --   return true
  -- end)

  -- estore:seekEntity(hasName('grid1'), function(e)
  --   local turnspeed = math.pi / 4
  --   local turn = turnspeed * input.dt
  --   e.rot.r = e.rot.r - turn
  --   return true
  -- end)

  -- estore:walkEntities(
  --   allOf(hasTag('clickable'), hasComps('b')),
  -- )
  -- EventHelpers.handle(input.events, 'touch', {
  --   moved = function(event)
  --     local x, y = event.x, event.y
  --     -- local clbls = findEntities(estore, allOf(hasTag('clickable'), hasComps('b')))
  --     estore:walkEntities(
  --       allOf(hasTag('clickable'), hasComps('tr', 'b')),
  --       function(e)
  --         -- local x1, y1, x2, y2 = calcBounds(e)
  --         if math.pointinrect(x, y, calcBounds(e)) then
  --           print("contact! " .. inspect({ x, y }))
  --         end
  --       end)
  --   end
  -- })

  -- pan to the right:
  local baseE = estore:getEntityByName("base")
  baseE.tr.x = baseE.tr.x - (30 * input.dt)
  -- zoom slowly:
  baseE.tr.sx = baseE.tr.sx + (0.05 * input.dt)
  baseE.tr.sy = baseE.tr.sx

  -- spin things:
  estore:walkEntities(
    allOf(hasTag('spinme'), hasComps('tr', 'state')),
    function(e)
      if e.states.spinspeed then
        e.tr.r = e.tr.r + (e.states.spinspeed.value * input.dt)
      end
    end)
end

--   local viewportE = Entities.getViewport(estore)

--   EventHelpers.handle(input.events, 'keyboard', {
--     pressed = function(event)kkkk
-- return function(estore, input, res)
--   -- local viewportE = Entities.getViewport(estore)
--   -- EventHelpers.handle(input.events, 'keyboard', {
--   --   pressed = function(event)
--   --   end
--   -- })
-- end
