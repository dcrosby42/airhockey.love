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
    EventHelpers.handle(input.events, "keyboard", {
      pressed = function(evt)
        keyst.pressed[evt.key] = true
        keyst.held[evt.key] = true
      end,
      released = function(evt)
        keyst.pressed[evt.key] = false
        keyst.held[evt.key] = false
      end,
    })
  end)
