local Debug = require('mydebug').sub('ecs.sound', true, true)

--
-- Sound component helpers
--

local function newComponent(e, name, res)
  if not name then return end
  local cfg = res.sounds[name]
  if cfg then
    return e:newComp('sound', {sound = name, volume = cfg.volume or 1})
  else
    Debug.println("(No sound for " .. tostring(name) .. ")")
    return nil
  end
end

return {newComponent = newComponent}
