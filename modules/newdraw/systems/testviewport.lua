local EventHelpers = require "castle.systems.eventhelpers"
local Comps = require "castle.components"

-- Controller: mapping keyboard keys to "d-pad" style directional control, wasd and arrow keys
local Con = {
  up = function(keyst)
    return keyst.held["w"] or keyst.held["up"]
  end,
  down = function(keyst)
    return keyst.held["s"] or keyst.held["down"]
  end,
  left = function(keyst)
    return keyst.held["a"] or keyst.held["left"]
  end,
  right = function(keyst)
    return keyst.held["d"] or keyst.held["right"]
  end,
}

local function shifted(keyst, normal_val, shifted_val)
  if keyst.held["lshift"] or keyst.held["rshift"] then
    return shifted_val
  end
  return normal_val
end

local STEP_SLOW = 10
local STEP_FAST = 20
local ZFACT_FAST = 0.05
local ZFACT_SLOW = 0.01

return defineUpdateSystem(hasName("viewport"),
  function(e, estore, input, res)
    local keyst = e.keystate
    if Con.left(keyst) then
      local step = shifted(keyst, STEP_SLOW, STEP_FAST)
      e.tr.x = e.tr.x + step
    end
    if Con.right(keyst) then
      local step = shifted(keyst, STEP_SLOW, STEP_FAST)
      e.tr.x = e.tr.x - step
    end
    if Con.up(keyst) then
      local step = shifted(keyst, STEP_SLOW, STEP_FAST)
      e.tr.y = e.tr.y + step
    end
    if Con.down(keyst) then
      local step = shifted(keyst, STEP_SLOW, STEP_FAST)
      e.tr.y = e.tr.y - step
    end
    if keyst.held["q"] then
      local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
      e.tr.sx = e.tr.sx - (zfact * e.tr.sx)
      e.tr.sy = e.tr.sx
    end
    if keyst.held["e"] then
      local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
      e.tr.sx = e.tr.sx + (zfact * e.tr.sx)
      e.tr.sy = e.tr.sx
    end
    if keyst.pressed["0"] then
      e.tr.x = 0
      e.tr.y = 0
      if keyst.held["lshift"] or keyst.held["rshift"] then
        e.tr.sx = 1
        e.tr.sy = 1
      end
    end
    if keyst.pressed["1"] then
      e.tr.sx = 1
      e.tr.sy = 1
    end
    if keyst.pressed["2"] then
      e.tr.sx = 2
      e.tr.sy = 2
    end
  end)
