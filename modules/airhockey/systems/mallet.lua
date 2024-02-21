local Debug = require("mydebug").sub("Mallet", true, true)
local inspect = require "inspect"

return defineUpdateSystem(allOf(hasComps("touch", "pos"), hasTag("mallet")), function(e, estore, input, res)
  if e.touch.state == "moved" then
    local boost = 30
    e.pos.x = e.touch.lastx - e.touch.offx
    e.pos.y = e.touch.lasty - e.touch.offy
    e.vel.dx = e.touch.lastdx * boost
    e.vel.dy = e.touch.lastdy * boost
  else
    e.vel.dx = 0
    e.vel.dy = 0
  end
  -- Debug.println(inspect(e.touch))
  -- Debug.println("hi")
end)
