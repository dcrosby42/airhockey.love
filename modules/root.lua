local Switcher = require('castle.modules.switcher')
local GM = require('castle.ecs.gamemodule')

local ModuleMap = {
  airhockey = GM.newFromFile("modules/airhockey/resources.lua"),
  newdraw = GM.newFromFile("modules/newdraw/resources.lua"),
  girl = GM.newFromFile("modules/girl/resources.lua"),
}

local function ifKeyPressed(action, key, fn)
  if action and
      action.type == "keyboard" and
      action.state == "pressed" and
      action.key == key then
    fn()
  end
end

local M = {}

function M.newWorld()
  local w = {}
  w.switcher = Switcher.newWorld({ modules = ModuleMap, current = "airhockey" })
  return w
end

function M.updateWorld(w, action)
  ifKeyPressed(action, "f1", function()
    action = { type = "castle.switcher", index = "airhockey" }
  end)
  ifKeyPressed(action, "f2", function()
    action = { type = "castle.switcher", index = "newdraw" }
  end)
  ifKeyPressed(action, "f3", function()
    action = { type = "castle.switcher", index = "girl" }
  end)

  local sidefx
  w.switcher, sidefx = Switcher.updateWorld(w.switcher, action)

  return w, sidefx
end

function M.drawWorld(w)
  Switcher.drawWorld(w.switcher)
end

return M
