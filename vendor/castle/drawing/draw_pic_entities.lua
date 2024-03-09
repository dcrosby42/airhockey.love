local mk_entity_draw_loop = require 'castle.drawing.mk_entity_draw_loop'

local function draw(e, pic, res)
  local picRes = res.pics[pic.id]
  if not picRes then
    error("No pic resource '" .. pic.id .. "'")
  end

  local x, y, r = pic.x, pic.y, pic.r
  local sx, sy = pic.sx, pic.sy
  local offx = pic.centerx * picRes.rect.w
  local offy = pic.centery * picRes.rect.h

  love.graphics.setColor(pic.color)
  love.graphics.draw(picRes.image, picRes.quad, x, y, r, sx, sy, offx, offy)

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

return mk_entity_draw_loop('pics', draw)
