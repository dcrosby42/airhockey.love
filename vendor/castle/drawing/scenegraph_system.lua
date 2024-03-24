local withTransform = require("castle.drawing.with_transform")
local BGColorSystem = require("castle.drawing.bgcolor_system")

local drawFuncs = {
  require('castle.drawing.draw_screengrid_entity'),
  require('castle.drawing.draw_pic_entities'),
  require('castle.drawing.draw_anim_entities'),
  require('castle.drawing.draw_geom_entities'),
  require('castle.drawing.draw_button_entities'),
  require('castle.drawing.draw_physics_entities'),
  require('castle.drawing.draw_label_entities'),
  require('castle.drawing.draw_sound_entities'),
}

-- Walk the Entity hierarchy and apply drawing functions.
-- Entities with tr components will have their transforms applied as
-- their children are drawn.
return function(estore, res)
  BGColorSystem(estore, res)
  estore:walkEntities2(nil, function(e, proceed)
    if e.tr then
      -- Transformed drawing:
      withTransform(e.tr.x, e.tr.y, e.tr.r, 0, 0, e.tr.sx, e.tr.sy, function()
        for i = 1, #drawFuncs do
          drawFuncs[i](e, res)
        end
        proceed()
      end)
    else
      -- Regular (non-transformed) drawing:
      for i = 1, #drawFuncs do
        drawFuncs[i](e, res)
      end
      proceed()
    end
  end)
end
