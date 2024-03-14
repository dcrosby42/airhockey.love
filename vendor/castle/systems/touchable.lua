local EventHelpers = require 'castle.systems.eventhelpers'
local Debug = require('mydebug').sub("Touchable", false, false)
local Vec = require 'vector-light'
local inspect = require "inspect"

local function touchName(id)
  return "touch-" .. tostring(id)
end

local function toVPCoords(x, y, estore)
  -- (THIS IS IMPLEMENTED IN elwens_animals BUT NOT HERE YET)
  -- return screenXYToViewport(Entities.getViewport(estore), x, y)
  return x, y
end

-- TODO: FACTOR THIS INTO ecshelpers.lua
local function hasLocation(e)
  return not not (e.pos or e.tr)
end

-- TODO: FACTOR THIS INTO ecshelpers.lua
-- TODO: when and how to consider parent transform...?
local function getLocation(e)
  if e.tr then
    return e.tr.x, e.tr.y
  elseif e.pos then
    return e.pos.x, e.pos.y
  end
  error("getLocation() requires e.tr or e.pos")
end

local function findTouchable(estore, touchEvt)
  local x, y = toVPCoords(touchEvt.x, touchEvt.y, estore)
  return findEntity(estore, function(e)
    if e.touchable and e.touchable.enabled and hasLocation(e) then
      local ex, ey = getLocation(e)
      ex = ex + e.touchable.offx
      ey = ey + e.touchable.offy
      local d = Vec.dist(x, y, ex, ey)
      local hitting = Vec.dist(x, y, ex, ey) <= e.touchable.radius
      Debug.println("findTouchable: x,y=" .. inspect({ x, y }) .. " d=" .. d .. " hittint=" .. tostring(hitting))
      return hitting
    end
    return false
  end)
end

local function findTouch(estore, tid)
  local e = findEntity(estore, function(e)
    return e.touch and e.touch.touchid == tid
  end)
  if e then
    if e.touch.touchid == tid then
      return e, e.touch
    else
      local comp = e.touchs[touchName(tid)]
      if not comp then
        Debug.println("??? findTouch eid=" .. e.eid .. " mishandling touchid=" .. tid)
        return nil, nil
      else
        return e, comp
      end
    end
  else
    return nil, nil
  end
end

local function touchdebug(comp)
  -- return inspect(comp, { newline = "" })
  return attrstring(comp,
    { "touchid", "state", "lastx", "lasty", "lastscreenx", "lastscreeny", "startx", "starty", "startscreenx",
      "startscreeny" })
end

local function updateTouchComp(touchComp, touchEvt, estore)
  local x, y = toVPCoords(touchEvt.x, touchEvt.y, estore)
  touchComp.touchid = touchEvt.id
  touchComp.state = touchEvt.state
  touchComp.lastx = x
  touchComp.lasty = y
  touchComp.lastscreenx = touchEvt.x
  touchComp.lastscreeny = touchEvt.y
  touchComp.lastdx = touchEvt.dx
  touchComp.lastdy = touchEvt.dy
  return touchComp
end

return function(estore, input, res)
  -- 'released' touches only live for 1 trip around the update loop:
  estore:walkEntities(hasComps('touch'), function(e)
    for _, touchComp in pairs(e.touchs) do
      if touchComp.state == 'released' then
        Debug.println("cleanup " .. touchdebug(touchComp))
        e:removeComp(touchComp)
      else
        -- Touch components are "idle" between actual touch events
        touchComp.state = 'idle'
        -- Gotta update viewport-relative coords each times, because the viewport moves around
        touchComp.lastx, touchComp.lasty = toVPCoords(touchComp.lastscreenx, touchComp.lastscreeny, estore)
      end
    end
  end)

  EventHelpers.handle(input.events, 'touch', {
    pressed = function(touch)
      local e = findTouchable(estore, touch)
      if e then
        local touchComp = e:newComp('touch', { name = touchName(touch.id) })
        updateTouchComp(touchComp, touch, estore)
        touchComp.startx = touchComp.lastx
        touchComp.starty = touchComp.lasty
        touchComp.startscreenx = touch.x
        touchComp.startscreeny = touch.y
        if hasLocation(e) then
          local x, y = getLocation(e)
          touchComp.offx = touchComp.startx - x
          touchComp.offy = touchComp.starty - y
        end
        Debug.println("pressed: " .. touchdebug(touchComp))
      end
    end,

    moved = function(touch)
      local e, touchComp = findTouch(estore, touch.id)
      if e and touchComp and touchComp.state ~= "released" then
        -- (ignore moved events if released has already been processed)
        updateTouchComp(touchComp, touch, estore)
        Debug.println("moved: " .. touchdebug(touchComp))
      end
    end,

    released = function(touch)
      local e, touchComp = findTouch(estore, touch.id)
      if e then
        updateTouchComp(touchComp, touch, estore)
        Debug.println("released: " .. touchdebug(touchComp))
      end
      -- NB: state will be set to 'released'; during the next update, the top of this func will remove the component
    end,
  })
end
