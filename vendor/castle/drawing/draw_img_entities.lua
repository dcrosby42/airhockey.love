require "castle.drawing.drawhelpers"
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

  if debugDraw(img, res) then
    -- circle at 0,0 in this entity's transform
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.circle("line", 0, 0, 5)

    -- (offset requires manual scaling here; the above .draw does this on the fly)
    local scox, scoy = ox * img.sx, oy * img.sy
    local x, y = img.x - scox, img.y - scoy
    -- withTransform(x, y, img.r, ox, oy, img.sx, img.sy, function()
    withTransform(x, y, img.r, scox, scoy, img.sx, img.sy, function()
      -- greay img bounding box
      love.graphics.setColor(0.3, 0.3, 0.3)
      love.graphics.rectangle("line", 0, 0, w, h)

      -- red,green axes @ x,y
      love.graphics.setColor(1, 0, 0)
      love.graphics.line(0, 0, w, 0)
      love.graphics.setColor(0, 1, 0)
      love.graphics.line(0, 0, 0, h)
    end)
  end
end

return mk_entity_draw_loop('imgs', draw)
