local withTransform = require("castle.drawing.with_transform")
local drawFuncs = {
  require('castle.drawing.draw_screengrid_entity'),
  require('castle.drawing.draw_pic_entities'),
  require('castle.drawing.draw_img_entities'),
  -- DrawPic.drawAnims,
  require('castle.drawing.draw_geom_entities'),
  require('castle.drawing.draw_label_entities'),


  -- pic
  -- shapes
  -- physics
  -- button
  -- sound?
}

return function(estore, res)
  estore:walkEntities2(nil, function(e, proceed)
    if e.tr then
      withTransform(e.tr.x, e.tr.y, e.tr.r, 0, 0, e.tr.sx, e.tr.sy, function()
        for i = 1, #drawFuncs do
          drawFuncs[i](e, res)
        end
        proceed()
      end)
    else
      for i = 1, #drawFuncs do
        drawFuncs[i](e, res)
      end
      proceed()
    end

    -- -- Apply transformation (if any)
    --     love.graphics.push()
    -- if e.tr then
    --   -- new style
    --   -- translate:
    --   love.graphics.translate(e.tr.x, e.tr.y)
    --   -- rotate:
    --   -- love.graphics.translate(e.rot.aboutx, e.rot.abouty)
    --   love.graphics.rotate(e.tr.r)
    --   -- love.graphics.translate(-e.rot.aboutx, -e.rot.abouty)
    --   -- scale:
    --   love.graphics.scale(e.tr.sx, e.tr.sy)
    -- else
    --   -- old style
    --   if e.pos then
    --     love.graphics.translate(e.pos.x, e.pos.y)
    --   end
    --   if e.rot then
    --     love.graphics.translate(e.rot.aboutx, e.rot.abouty)
    --     love.graphics.rotate(e.rot.r)
    --     love.graphics.translate(-e.rot.aboutx, -e.rot.abouty)
    --   end
    --   if e.scale then
    --     love.graphics.scale(e.scale.x, e.scale.y)
    --   end
    -- end

    -- -- Draw entity
    -- for i = 1, #drawFuncs do
    --   drawFuncs[i](e, res)
    -- end

    -- -- Draw children
    -- proceed()

    -- -- End transform
    -- love.graphics.pop()
  end)
end
