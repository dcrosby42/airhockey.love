local inspect = require "inspect"
local EventHelpers = require "castle.systems.eventhelpers"

-- Compute rectangle coords from a 'b' or 'rect2' component.
-- Expected attrs on component: x,y,w,h,cx,cy
-- Returns rectangle as: x1,y1,x2,y2
local function bounds2rect(b)
  local w, h = b.w, b.h
  local ox = b.cx * w
  local oy = b.cy * h
  local x, y = b.x - ox, b.y - oy
  return x, y, x + w, y + h
end

-- local function calcBounds(e)
--   if not e.b then
--     error("calcBounds needs an entity with a 'b' component")
--   end
--   local x1, y1, x2, y2 = bounds2rect(e.b)
--   -- print("bounds2rect: " .. inspect({ x1, y1, x2, y2 }))
--   local t = calcTransform(e)
--   if t then
--     local tx1, ty1 = t:transformPoint(x1, y1)
--     local tx2, ty2 = t:transformPoint(x2, y2)
--     return tx1, ty1, tx2, ty2
--   else
--     return x1, y1, x2, y2
--   end
-- end


return function(estore, input, res)
  -- Get the "findme" entity and its transform:
  local findme = estore:getEntityByName("findme")
  if not findme then return end
  local findmeT = computeEntityTransform(findme)

  EventHelpers.on(input.events, 'touch', 'pressed', function(evt)
    local greenDot = estore:getEntityByName("greenDot")
    if greenDot then
      -- transform screen coords -> findme-relative coords:
      local tx, ty = findmeT:inverseTransformPoint(evt.x, evt.y)
      if math.pointinrect(tx, ty, bounds2rect(findme.b)) then
        print("inverseTransformed click:" .. inspect({ tx, ty }))
        greenDot.tr.x = tx
        greenDot.tr.y = ty
      end
    end
  end)

  -- Move blueDot to the screen coords indicated by findme's transform:
  local blueDot = estore:getEntityByName("blueDot")
  local x, y = findmeT:transformPoint(15, -13)
  blueDot.tr.x = x
  blueDot.tr.y = y

  -- mouse pointer tracking dot
  local selectbox = estore:getEntityByName("selectbox")
  if selectbox then
    -- move the dot to where the mouse is
    EventHelpers.on(input.events, 'touch', 'moved', function(evt)
      selectbox.tr.x = evt.x
      selectbox.tr.y = evt.y
    end)
    -- check for intersection with the "findme" box
    local x, y = selectbox.tr.x, selectbox.tr.y
    x, y = findmeT:inverseTransformPoint(x, y)
    if math.pointinrect(x, y, bounds2rect(findme.b)) then
      -- turn red if we're hitting the box
      selectbox.circle2.color = { 1, 0, 0 }
    else
      selectbox.circle2.color = { 1, 1, 1 }
    end
  end
end
