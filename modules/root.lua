local Switcher = require('castle.modules.switcher')
local GM = require('castle.ecs.gamemodule')

local ModuleMap = {
  f1 = GM.newFromFile("modules/airhockey/resources.lua"),
  f2 = GM.newFromFile("modules/newdraw/resources.lua"),
}

local M = {}

function M.newWorld()
  local w = {}
  w.switcher = Switcher.newWorld({ modules = ModuleMap, current = "f1" })
  return w
end

function M.updateWorld(w, action)
  if action.type == "keyboard" and action.state == "pressed" then
    if ModuleMap[action.key] then
      action = { type = "castle.switcher", index = action.key }
    end
  end

  local sidefx
  w.switcher, sidefx = Switcher.updateWorld(w.switcher, action)

  return w, sidefx
end

function M.drawWorld(w)
  Switcher.drawWorld(w.switcher)
end

return M
