local EventHelpers = require "castle.systems.eventhelpers"
local Comps = require "castle.components"

Comps.define('keystate', {
  'pressed', {},
  'held', {},
  'released', {},
})

return defineUpdateSystem({ "keystate" },
  function(e, estore, input, res)
    local keyst = e.keystate
    for key, _ in pairs(keyst.pressed) do
      keyst.pressed[key] = false
    end
    for key, _ in pairs(keyst.released) do
      keyst.released[key] = false
    end
    EventHelpers.handle(input.events, "keyboard", {
      pressed = function(evt)
        keyst.pressed[evt.key] = true
        keyst.held[evt.key] = true
        -- return false
      end,
      released = function(evt)
        keyst.pressed[evt.key] = false
        keyst.held[evt.key] = false
        keyst.released[evt.key] = true
        -- return false
      end,
    })
  end)
