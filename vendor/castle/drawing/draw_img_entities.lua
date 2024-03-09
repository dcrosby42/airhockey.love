local mk_entity_draw_loop = require 'castle.drawing.mk_entity_draw_loop'
local withTransform = require("castle.drawing.with_transform")

local function draw(e, img, res)
  local picRes = res.pics[img.img]
  if not picRes then
    error("No pic resource '" .. img.img .. "'")
  end

  local w, h = picRes.rect.w, picRes.rect.h
  local ox = img.cx * w
  local oy = img.cy * h

  love.graphics.setColor(img.color)

  love.graphics.draw(picRes.image, picRes.quad, img.x, img.y, img.r, img.sx, img.sy, ox, oy)

  if img.debug then
    local x, y = img.x - ox, img.y - oy

    -- 0,0 in this entity's transform
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.circle("line", 0, 0, 5)

    withTransform(x, y, img.r, ox, oy, img.sx, img.sy, function()
      -- greay img bounding box
      love.graphics.setColor(0.3, 0.3, 0.3)
      love.graphics.rectangle("line", 0, 0, w, h)

      -- red,green axes @ x,y
      love.graphics.setColor(1, 0, 0)
      love.graphics.line(0, 0, w, 0)
      love.graphics.setColor(0, 1, 0)
      love.graphics.line(0, 0, 0, h)
    end)




    -- love.graphics.setColor(1, 0.5, 0.5)
    -- love.graphics.circle("fill", img.x, img.y, 3)
  end

  -- local offx = 0
  -- local offy = 0
  -- if pic.centerx ~= "" then
  --   offx = pic.centerx * picRes.rect.w
  -- else
  --   offx = pic.offx
  -- end
  -- if pic.centery ~= "" then
  --   offy = pic.centery * picRes.rect.h
  -- else
  --   offy = pic.offy
  -- end

  -- love.graphics.draw(picRes.image, picRes.quad, x, y, r, pic.sx, pic.sy, offx, offy)

  -- if pic.drawbounds then
  --   G.rectangle("line", x - (pic.sx * offx), y - (pic.sy * offy), picRes.rect.w * pic.sx, picRes.rect.h * pic.sy)
  -- end
end

return mk_entity_draw_loop('imgs', draw)
