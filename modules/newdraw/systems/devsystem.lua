local EventHelpers = require "castle.systems.eventhelpers"
-- local Entities     = require "modules.newdraw.entities"

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

  estore:walkEntities(
    allOf(hasTag('spinme'), hasComps('state')),
    function(e)
      if e.states.spinspeed then
        e.rot.r = e.rot.r + (e.states.spinspeed.value * input.dt)
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
