local NormFuncs = require "castle.tween.normfuncs"
local inspect = require "inspect"

local Tween = {}


function Tween.apply(e)
  if not e.tweens then
    return
  end
  if not e.timers then
    error("entity with tween should also have timers!")
  end
  for _, tween in pairs(e.tweens) do
    local timer = e.timers[tween.timer]
    if not timer then
      error("tween timer'" .. tween.timer .. "' not found")
    end
    local func = NormFuncs[tween.func]
    if not func then
      error("tween func '" .. tween.func .. "' not found")
    end

    local comp
    if type(tween.comp) == 'string' then
      -- For supporting component-by-type, eg, "tr"
      comp = e[tween.comp]
    elseif type(tween.comp) == 'table' then
      -- For supporting component-by-name, eg, {"timers","fader"}
      comp = e[tween.comp[1]][tween.comp[2]]
    end
    if not comp then
      error("tween comp " .. inspect(tween.comp) .. " not found")
    end

    local t = math.min(timer.t / tween.duration, 1)
    local from = tween.from
    local to = tween.to
    if type(from) == "table" then
      -- assume list of numbers: (eg, color)
      for i = 1, #from do
        comp[tween.prop][i] = func(from[i], to[i], t)
      end
    else
      -- normal numeric values:
      comp[tween.prop] = func(from, to, t)
    end

    if t >= 1 then
      comp[tween.prop] = tween.to
      if tween.killtimer then
        e:removeComp(timer)
      end
      e:removeComp(tween)
    end
  end
end

return Tween
