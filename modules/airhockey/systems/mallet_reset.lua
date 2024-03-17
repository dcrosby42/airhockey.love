local Debug = require("mydebug").sub("MalletReset", true, true)
local E = require "modules.airhockey.entities"
local EventHelpers = require "castle.systems.eventhelpers"

return defineUpdateSystem(hasTag("mallet"),
  function(e, estore, input, res)
    EventHelpers.on(input.events, "mallet_reset", function(evt)
      if evt.state == "p1" then
        local prevE = estore:getEntityByName("mallet_p1")
        local parent = prevE:getParent()
        estore:destroyEntity(prevE)
        E.mallet_p1(parent, res)
        Debug.println("reset mallet " .. evt.state)
      elseif evt.state == "p2" then
        local prevE = estore:getEntityByName("mallet_p2")
        local parent = prevE:getParent()
        estore:destroyEntity(prevE)
        E.mallet_p2(parent, res)
        Debug.println("reset mallet " .. evt.state)
      end
    end)
  end)
