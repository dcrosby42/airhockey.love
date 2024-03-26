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

local function updateCamera(e)
  local keyst = e.keystate
  if keyst.held["a"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST)
    e.tr.x = e.tr.x - step
  end
  if keyst.held["d"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST)
    e.tr.x = e.tr.x + step
  end
  if keyst.held["w"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST)
    e.tr.y = e.tr.y - step
  end
  if keyst.held["s"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST)
    e.tr.y = e.tr.y + step
  end
  if keyst.held["q"] then
    e.tr.r = e.tr.r - 0.01
    -- local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
    -- e.box.w = e.box.w - (zfact * e.box.w)
    -- e.box.h = e.box.h - (zfact * e.box.h)
  end
  if keyst.held["e"] then
    e.tr.r = e.tr.r + 0.01
    -- local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
    -- e.box.w = e.box.w + (zfact * e.box.w)
    -- e.box.h = e.box.h + (zfact * e.box.h)
  end
end

local function updateViewport(e)
  local keyst = e.keystate
  -- local loc = e.box
  local loc = e.tr
  local inv = 1
  if keyst.held["left"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST) * inv
    loc.x = loc.x - step
  end
  if keyst.held["right"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST) * inv
    loc.x = loc.x + step
  end
  if keyst.held["up"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST) * inv
    loc.y = loc.y - step
  end
  if keyst.held["down"] then
    local step = shifted(keyst, STEP_SLOW, STEP_FAST) * inv
    loc.y = loc.y + step
  end
  if keyst.held[","] then
    local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
    loc.sx = loc.sx + (zfact * loc.sx)
    loc.sy = loc.sx
  end
  if keyst.held["."] then
    local zfact = shifted(keyst, ZFACT_SLOW, ZFACT_FAST)
    loc.sx = loc.sx - (zfact * loc.sx)
    loc.sy = loc.sx
  end


  -- if keyst.pressed["0"] then
  --   e.tr.x = 0
  --   e.tr.y = 0
  --   if keyst.held["lshift"] or keyst.held["rshift"] then
  --     e.tr.sx = 1
  --     e.tr.sy = 1
  --   end
  -- end
  -- if keyst.pressed["1"] then
  --   e.tr.sx = 1
  --   e.tr.sy = 1
  -- end
  -- if keyst.pressed["2"] then
  --   e.tr.sx = 2
  --   e.tr.sy = 2
  -- end
end

return defineUpdateSystem(hasName("viewport"),
  function(e, estore, input, res)
    -- local vp = e

    local camE = estore:getEntityByName("cam1")

    updateCamera(camE)
    updateViewport(e)
  end)
