local withTransform = require("castle.drawing.with_transform")

local function drawPicLike(comp, picRes, res)
  local w, h = picRes.rect.w, picRes.rect.h
  local ox, oy = comp.cx * w, comp.cy * h
  local sx, sy = comp.sx * picRes.sx, comp.sx * picRes.sy

  love.graphics.setColor(comp.color)
  love.graphics.draw(picRes.image, picRes.quad, comp.x, comp.y, comp.r, sx, sy, ox, oy)

  if debugDraw(comp, res) then
    -- circle at 0,0 in this entity's transform
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.circle("line", 0, 0, 5)
    -- little red/green axes at origin
    local len = 10
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(0, 0, len, 0)
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(0, 0, 0, len)

    -- (offset requires manual scaling here; the above .draw does this on the fly)
    local scox, scoy = ox * sx, oy * sy
    local x, y = comp.x - scox, comp.y - scoy
    withTransform(x, y, comp.r, scox, scoy, sx, sy, function()
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
