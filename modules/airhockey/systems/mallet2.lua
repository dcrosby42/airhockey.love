local Debug = require("mydebug").sub("Mallet", false, false)
local inspect = require "inspect"

local Impact = 15

-- Update the location of e based on touch location.
-- Touch is in screen coords; dragging happens in e's parent space.
local function dragPosition(e, xform)
  local touch = e.touch
  local screenx, screeny = touch.x, touch.y
  -- The touch point in parent-relative coords:
  local parx, pary = xform:inverseTransformPoint(screenx, screeny)
  -- Adjustment based on the initial offset of touch-vs-entity
  -- (step1: tranform the initial ent-relative point, to be parent-relative)
  local par_x0, par_y0 = trToTransform(e.tr):transformPoint(touch.init_ex, touch.init_ey)
  -- (step2: subtract the translation component:)
  local offx = par_x0 - e.tr.x
  local offy = par_y0 - e.tr.y

  -- Update position:
  e.tr.x = parx - offx
  e.tr.y = pary - offy
end

-- Update the velocity of e based on touch motion.
-- Touch is in screen coords; dragging happens in e's parent space.
local function dragVelocity(e, xform)
  local t = e.touch
  local dx, dy = subtractInverseTransformed(xform, t.x, t.y, t.prev_x, t.prev_y)
  e.vel.dx = dx * Impact
  e.vel.dy = dy * Impact
end

-- Control the mallets (paddles) by touch-n-drag
return defineUpdateSystem(allOf(hasComps("touch"), hasTag("mallet")),
  function(e, estore, input, res)
    if e.touch.state == "moved" then
      local xform = computeEntityTransform(e:getParent())
      dragPosition(e, xform)
      dragVelocity(e, xform)
    else
      e.vel.dx = 0
      e.vel.dy = 0
    end
    if e.touch.state ~= "idle" then
      Debug.println(function()
        return "touch= " ..
            e.touch.state .. " x,y=" .. inspect({ e.tr.x, e.tr.y }) .. " vel=" .. inspect({ e.vel.dx, e.vel.dy })
      end)
    end
  end)
