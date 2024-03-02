local inspect = require('inspect')
local G = love.graphics

local function reset()
  G.setColor(1, 1, 1, 1)
  G.setFont(INITIAL_FONT)
end

local function drawRotatedRectangle(mode, x, y, width, height, angle, offx, offy)
  -- We cannot rotate the rectangle directly, but we
  -- can move and rotate the coordinate system.
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(angle)
  -- love.graphics.rectangle(mode, -offx, -offy, width, height) -- origin in the top left corner
  love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
  --	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the middle
  love.graphics.pop()
end

local function drawLabel(e, label, res)
  if label.font then
    -- lookup font and apply it
    local font = res.fonts[label.font]
    if font then G.setFont(font) end
  end

  local r = 1
  local g = 1
  local b = 1
  local a = 1
  if (label.color) then r, g, b, a = unpack(label.color) end
  if not a then a = 1 end

  -- figure out position, alignment etc
  local x, y = getPos(e)
  local align = label.align or "left"
  local rot = label.r or 0
  local width, height = label.width, label.height
  if width == 0 or width == '' then
    width = nil
  end
  local sx, sy = 1, 1
  local offx, offy = label.offx, label.offy


  if (label.debugdraw and width > 0 and height > 0) then
    G.setColor(r, g, b, a)
    -- G.rectangle('line', x, y, width, height)
    drawRotatedRectangle("line", x, y, width, height, rot, offx, offy)
  end

  if height > 0 then
    if label.valign == "middle" then
      local halfLineH = G.getFont():getHeight() / 2
      y = y + (height / 2) - halfLineH
    elseif label.valign == "bottom" then
      local lineH = G.getFont():getHeight()
      y = y + height - lineH
    end
  end

  -- print with width and alignment
  -- love.graphics.printf( text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
  if label.shadowcolor then
    G.setColor(unpack(label.shadowcolor))
    G.printf(label.text, x + label.shadowx, y + label.shadowy, width, align, rot)
  end
  G.setColor(r, g, b, a)
  G.printf(label.text, x, y, width, align, rot)

  reset()
end

local function drawLabels(e, res)
  if e.label then
    for _cid, label in pairs(e.labels) do
      drawLabel(e, label, res)
    end
  end
end

local function drawRect(e, rect, res)
  if not e.rect.draw then return end
  local x, y = getPos(e)
  love.graphics.setColor(unpack(rect.color))
  print(rect.style)
  love.graphics.rectangle(rect.style, x - rect.offx, y - rect.offy, rect.w, rect.h)
  reset()
end

local function drawRects(e, res)
  if e.rect then
    for _cid, rect in pairs(e.rects) do
      drawRect(e, rect, res)
    end
  end
end


return {
  drawLabels = drawLabels,
  drawRects = drawRects,
  drawRotatedRectangle = drawRotatedRectangle,
}
