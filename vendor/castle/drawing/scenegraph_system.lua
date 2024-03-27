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

local function withCameraTransform(cameraEnt, callback)
  local transf = computeCameraTransform(cameraEnt)
  love.graphics.push()
  love.graphics.applyTransform(transf)
  callback()
  love.graphics.pop()
end

local function withViewportCameraTransform(viewportE, cameraEnt, callback)
  local transf = computeCameraTransform(cameraEnt)

  -- local bw, bh = viewportE.box.w, viewportE.box.h
  -- local sbw, sbh = trToTransform(cameraEnt.tr):transformPoint(bw / 2, bh / 2)
  -- local sbw, sbh = cameraEnt.tr.sx * bw / 2, cameraEnt.tr.sy * bh / 2
  -- print("b=" .. bw .. "," .. bh .. " sb=" .. sbw .. "," .. sbh)
  -- transf:translate(sbw, sbh)

  love.graphics.push()
  love.graphics.applyTransform(transf)
  callback()
  love.graphics.pop()
end

-- Walk the Entity hierarchy and apply drawing functions.
-- Entities with tr components will have their transforms applied as
-- their children are drawn.
return function(estore, res)
  BGColorSystem(estore, res)
  estore:walkEntities2(nil, function(e, continue)
    if e.viewport then
      withTransform(e.tr.x, e.tr.y, e.tr.r, 0, 0, e.tr.sx, e.tr.sy, function()
        local camE = estore:getEntityByName(e.viewport.camera)
        if e.box then
          withStencil(e.box, function()
            withCameraTransform(camE, continue)
            -- withViewportCameraTransform(e, camE, continue)
          end)
        else
          withCameraTransform(camE, continue)
        end
        drawEntity(e, res) -- eg, draw the viewport's box shape
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
