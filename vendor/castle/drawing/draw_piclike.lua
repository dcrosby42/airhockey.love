local withTransform = require("castle.drawing.with_transform")

local function drawPicLike(picLike, picRes, res)
  local w, h = picRes.rect.w, picRes.rect.h
  local ox, oy = picLike.cx * w, picLike.cy * h
  local sx, sy = picLike.sx * picRes.sx, picLike.sx * picRes.sy

  love.graphics.setColor(picLike.color)
  love.graphics.draw(picRes.image, picRes.quad, picLike.x, picLike.y, picLike.r, sx, sy, ox, oy)

  if debugDraw(picLike, res) then
    -- circle at 0,0 in this entity's transform
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.circle("line", 0, 0, 5)

    -- (offset requires manual scaling here; the above .draw does this on the fly)
    local scox, scoy = ox * picLike.sx, oy * picLike.sy
    local x, y = picLike.x - scox, picLike.y - scoy
    withTransform(x, y, picLike.r, scox, scoy, picLike.sx, picLike.sy, function()
      -- greay pic bounding box
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
return drawPicLike
