local Debug = require("mydebug").sub("Mallet", true, true)
local inspect = require "inspect"

local boost = 15

-- Control the mallets (paddles) by touch-n-drag
return defineUpdateSystem(allOf(hasComps("touch2"), hasTag("mallet")),
  function(e, estore, input, res)
    if e.touch2.state == "moved" then
      e.tr.x = e.touch2.x + e.touch2.offx
      e.tr.y = e.touch2.y + e.touch2.offy
      e.vel.dx = e.touch2.dx * boost
      e.vel.dy = e.touch2.dy * boost
    else
      e.vel.dx = 0
      e.vel.dy = 0
    end
    -- elseif e.touch2.state == "pressed" then
    --   e.vel.dx = 0
    --   e.vel.dy = 0
    -- elseif e.touch2.state == "idle" then
    --   e.vel.dx = 0
    --   e.vel.dy = 0
    -- elseif e.touch2.state == "released" then
    --   e.vel.dx = 0
    --   e.vel.dy = 0
    -- end
    -- if e.touch.state == "moved" then
    --   local boost = 15
    --   local x = e.touch.lastx - e.touch.offx
    --   local y = e.touch.lasty - e.touch.offy
    --   if e.tr then
    --     e.tr.x = x
    --     e.tr.y = y
    --   elseif e.pos then
    --     e.pos.x = x
    --     e.pos.y = y
    --   end
    --   e.vel.dx = e.touch.lastdx * boost
    --   e.vel.dy = e.touch.lastdy * boost
    -- else
    --   e.vel.dx = 0
    --   e.vel.dy = 0
    -- end
  end)
