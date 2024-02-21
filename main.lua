local Castle = require "vendor/castle/main"

Castle.module_name = "modules/root"
Castle.onload = function()
  -- x=1 y=1.43
  love.window.setMode(600, 858, {
    fullscreen = false,
    resizable = true,
    highdpi = false,
  })
end
