local Debug = require("mydebug").sub("PuckReset", true, true)
local E = require "modules.airhockey.entities"
local EventHelpers = require "castle.systems.eventhelpers"

return defineUpdateSystem(hasTag("puck"),
  function(e, estore, input, res)
    EventHelpers.on(input.events, "puck_reset", function(evt)
      local prevE = estore:getEntityByName("puck")
      local parent = prevE:getParent()
      estore:destroyEntity(prevE)
      E.puck_drop(parent, res)
      Debug.println("reset puck")
    end)
  end)
