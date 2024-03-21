require "castle.drawing.drawhelpers"
local mk_entity_draw_loop = require 'castle.drawing.mk_entity_draw_loop'
local withTransform = require("castle.drawing.with_transform")

local function draw(e, pic, res)
  local picRes = res.pics[pic.id]
  if not picRes then
    error("No pic resource '" .. pic.id .. "'")
  end

  local w, h = picRes.rect.w, picRes.rect.h
  local ox = pic.cx * w
  local oy = pic.cy * h

  love.graphics.setColor(pic.color)
  love.graphics.draw(picRes.image, picRes.quad, pic.x, pic.y, pic.r, pic.sx, pic.sy, ox, oy)

  if debugDraw(pic, res) then
    -- circle at 0,0 in this entity's transform
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.circle("line", 0, 0, 5)

    -- (offset requires manual scaling here; the above .draw does this on the fly)
    local scox, scoy = ox * pic.sx, oy * pic.sy
    local x, y = pic.x - scox, pic.y - scoy
    -- withTransform(x, y, pic.r, ox, oy, pic.sx, pic.sy, function()
    withTransform(x, y, pic.r, scox, scoy, pic.sx, pic.sy, function()
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

return mk_entity_draw_loop('pics', draw)

-- --
-- -- ANIM
-- --
-- if e.anims then
--   -- local anim = e.anim
--   for _, anim in pairs(e.anims) do
--     local animRes = res.anims[anim.id]
--     if not animRes then
--       error("No anim resource '" .. anim.id .. "'")
--     end
--     local timer = e.timers[anim.name]
--     if timer then
--       local picRes = animRes.getFrame(timer.t)
--       local x, y = getPos(e)
--       local r = 0
--       if anim.r then
--         r = r + anim.r
--       end
--       if e.pos.r then
--         r = r + e.anim.r
--       end

--       local offx = 0
--       local offy = 0
--       if anim.centerx ~= "" then
--         offx = anim.centerx * picRes.rect.w
--       else
--         offx = anim.offx
--       end
--       if anim.centery ~= "" then
--         offy = anim.centery * picRes.rect.h
--       else
--         offy = anim.offy
--       end

--       love.graphics.setColor(unpack(anim.color))

--       love.graphics.draw(picRes.image, picRes.quad, x, y, r, anim.sx, anim.sy, offx, offy)

--       if anim.drawbounds then
--         love.graphics.rectangle(
--           "line",
--           x - (anim.sx * offx),
--           y - (anim.sy * offy),
--           picRes.rect.w * anim.sx,
--           picRes.rect.h * anim.sy
--         )
--       end
--     else
--       print("For eid=" .. e.eid .. " anim.cid=" .. anim.cid .. " NEED TIMER named '" .. anim.name .. "'")
--     end -- end if timer
--   end
-- end
