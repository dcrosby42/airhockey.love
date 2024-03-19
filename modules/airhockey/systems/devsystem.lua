local EventHelpers = require "castle.systems.eventhelpers"

local function getState(e, sname)
  return e.states[sname].value
end

local function setState(e, sname, val)
  e.states[sname].value = val
  return val
end

local function toggleState(e, sname)
  setState(e, sname, not getState(e, sname))
  return getState(e, sname)
end

return defineUpdateSystem(hasName("dev_state"), function(e, estore, input, res)
  EventHelpers.onKeyPressed(input.events, "d", function(evt)
    res.data.debug_draw = toggleState(e, "debug_draw")
    print("debug " .. tostring(res.data.debug_draw))

    local viewroot = estore:getEntityByName("viewroot")
    if res.data.debug_draw then
      viewroot.tr.x = 100
      viewroot.tr.y = 100
      viewroot.tr.sx = 0.7
      viewroot.tr.sy = 0.7
    else
      viewroot.tr.x = 0
      viewroot.tr.y = 0
      viewroot.tr.sx = 1
      viewroot.tr.sy = 1
    end
  end)
end)
