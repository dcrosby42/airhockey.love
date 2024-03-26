local withTransform = require("castle.drawing.with_transform")
local BGColorSystem = require("castle.drawing.bgcolor_system")

local function withStencil(box, callback)
  love.graphics.stencil(function()
    love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  end, "replace", 1)
  -- Only allow rendering on pixels which have a stencil value greater than 0.
  love.graphics.setStencilTest("greater", 0)

  callback()

  love.graphics.setStencilTest()
end

local DrawFuncs = {
  require('castle.drawing.draw_screengrid_entity'),
  require('castle.drawing.draw_pic_entities'),
  require('castle.drawing.draw_anim_entities'),
  require('castle.drawing.draw_geom_entities'),
  require('castle.drawing.draw_button_entities'),
  require('castle.drawing.draw_physics_entities'),
  require('castle.drawing.draw_label_entities'),
  require('castle.drawing.draw_sound_entities'),
}

local function drawEntity(e, res)
  for i = 1, #DrawFuncs do
    DrawFuncs[i](e, res)
  end
end

-- Walk the Entity hierarchy and apply drawing functions.
-- Entities with tr components will have their transforms applied as
-- their children are drawn.
return function(estore, res)
  BGColorSystem(estore, res)
  estore:walkEntities2(nil, function(e, continue)
    if e.viewport and e.box then
      withTransform(e.tr.x, e.tr.y, e.tr.r, 0, 0, e.tr.sx, e.tr.sy, function()
        withStencil(e.box, function()
          local camE = estore:getEntityByName(e.viewport.camera)
          withTransform(
            e.box.w / 2 - camE.tr.x,
            e.box.h / 2 - camE.tr.y,
            0, 0, 0,
            1, 1, -- sx,sy -- camera.zoom?
            function()
              continue()
            end)
        end)
        drawEntity(e, res)
      end)
    elseif e.tr then
      withTransform(e.tr.x, e.tr.y, e.tr.r, 0, 0, e.tr.sx, e.tr.sy, function()
        drawEntity(e, res)
        continue()
      end)
    else
      -- Regular (non-transformed) drawing:
      drawEntity(e, res)
      continue()
    end
  end)
end
