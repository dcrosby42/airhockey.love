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
  --
  -- Toggle "debug mode" when "d" is pressed
  --
  if e.keystate.pressed["d"] then
    -- Set the "global" debug flag:
    res.data.debug_draw = toggleState(e, "debug_draw")

    -- Toggle camera zoom level (zoom out 50% in debug mode)
    local camE = estore:getEntityByName("camera1")
    if camE then
      local scale = 1
      if res.data.debug_draw then
        -- zoom out a bit so we can see the walls etc
        scale = 1.5
      end
      camE.tr.sx, camE.tr.sy = scale, scale
    end
  end
end)
