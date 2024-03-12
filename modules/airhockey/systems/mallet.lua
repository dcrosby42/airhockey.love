local Debug = require("mydebug").sub("Mallet", false, false)
local inspect = require "inspect"

-- Controll the mallets (paddles) by touch-n-drag
return defineUpdateSystem(allOf(hasComps("touch"), hasTag("mallet")), function(e, estore, input, res)
  if e.touch.state == "moved" then
    local boost = 10
    local x = e.touch.lastx - e.touch.offx
    local y = e.touch.lasty - e.touch.offy
    if e.tr then
      e.tr.x = x
      e.tr.y = y
    elseif e.pos then
      e.pos.x = x
      e.pos.y = y
    end
    e.vel.dx = e.touch.lastdx * boost
    e.vel.dy = e.touch.lastdy * boost
  else
    e.vel.dx = 0
    e.vel.dy = 0
  end
end)
