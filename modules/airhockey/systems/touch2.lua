local EventHelpers = require 'castle.systems.eventhelpers'
local Debug = require('mydebug').sub("Touch", false, false)
local inspect = require("inspect")

local touchPressed, touchMoved, touchReleased
local findTouch, cleanupTouches, touchName

local touchSystem = function(estore, input, res)
  cleanupTouches(estore)
  EventHelpers.handle(input.events, 'touch', {
    pressed = function(touchEvt)
      touchPressed(estore, touchEvt)
    end,
    moved = function(touchEvt)
      touchMoved(estore, touchEvt)
    end,
    released = function(touchEvt)
      touchReleased(estore, touchEvt)
    end,
  })
end

touchPressed = function(estore, touchEvt)
  estore:seekEntity(function(e)
    if not e.touchable2 then
      return false
    end

    local x, y = touchEvt.x, touchEvt.y

    -- Detect touch intersection:
    local ex, ey = screenToEntityPt(e, touchEvt.x, touchEvt.y)
    local targx, targy = e.touchable2.x, e.touchable2.y
    local d = math.dist(ex, ey, targx, targy)
    if d > e.touchable2.r then
      -- nope!
      return false
    end

    -- Add a new touch component to the entity
    e:newComp('touch2', {
      name = touchName(touchEvt.id),
      id = touchEvt.id,
      state = 'pressed',
      init_x = x,
      init_y = y,
      init_ex = ex,
      init_ey = ey,
      prev_x = x,
      prev_y = y,
      x = x,
      y = y,
    })
    Debug.println(function() return "Start touch " .. inspect(e.touch2) end)
  end)
  return true
end

touchMoved = function(estore, touchEvt)
  local e, touchComp = findTouch(estore, touchEvt.id)
  if e and touchComp and touchComp.state ~= "released" then
    touchComp.state = "moved"
    touchComp.prev_x = touchComp.x
    touchComp.prev_y = touchComp.y
    touchComp.x = touchEvt.x
    touchComp.y = touchEvt.y
    Debug.println(function() return "moved " .. inspect(e.touch2) end)
  end
end

touchReleased = function(estore, touchEvt)
  local e, touchComp = findTouch(estore, touchEvt.id)
  if e and touchComp then
    -- NB: state will be set to 'released'; during the next update, the top of
    -- this system will remove the touch component.
    touchComp.state = "released"
    if x ~= touchComp.x or y ~= touchComp.y then
      touchComp.dx = touchEvt.x - touchComp.x
      touchComp.dy = touchEvt.y - touchComp.y
      touchComp.x = touchEvt.x
      touchComp.y = touchEvt.y
    end
    Debug.println(function() return "released " .. inspect(e.touch2) end)
  end
end

cleanupTouches = function(estore, touchEvt)
  -- 'released' touches only live for 1 trip around the update loop:
  estore:walkEntities(hasComps('touch2'), function(e)
    for _, touchComp in pairs(e.touch2s) do
      if touchComp.state == 'released' then
        e:removeComp(touchComp)
      else
        -- Touch components are "idle" between actual touch events
        touchComp.state = 'idle'
      end
    end
  end)
end

touchName = function(id)
  return "touch-" .. tostring(id)
end

findTouch = function(estore, touchId)
  local e = findEntity(estore, function(e)
    return e.touch2 and e.touch2.id == touchId
  end)
  if e then
    if e.touch2.id == touchId then
      return e, e.touch2
    else
      local touchComp = e.touch2s[touchName(touchId)]
      if not touchComp then
        Debug.println("??? findTouch eid=" .. e.eid .. " mishandling touchid=" .. touchId)
        return nil, nil
      else
        return e, touchComp
      end
    end
  else
    return nil, nil
  end
end

return touchSystem
