local inspect = require('inspect')
local G = love.graphics

local function drawLabel(e, label, res)
  local wasFont
  if label.font then
    wasFont = G.getFont()
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

  if (label.debugdraw and label.width > 0 and label.height > 0) then
    G.setColor(r, g, b, a)
    G.rectangle('line', x, y, label.width, label.height)
  end

  if label.height > 0 then
    if label.valign == "middle" then
      local halfLineH = G.getFont():getHeight() / 2
      y = y + (label.height / 2) - halfLineH
    elseif label.valign == "bottom" then
      local lineH = G.getFont():getHeight()
      y = y + label.height - lineH
    end
  end

  if label.width > 0 then
    -- print with width and alignment
    width = label.width
    align = label.align
    if not align then align = "left" end
    if label.shadowcolor then
      G.setColor(unpack(label.shadowcolor))
      G.printf(label.text, x + label.shadowx, y + label.shadowy, label.width,
               label.align)
    end
    G.setColor(r, g, b, a)
    G.printf(label.text, x, y, label.width, label.align)
  else
    -- print normally
    if label.shadowcolor then
      G.setColor(unpack(label.shadowcolor))
      G.print(label.text, x + label.shadowx, y + label.shadowy)
    end
    G.setColor(r, g, b, a)
    G.print(label.text, x, y)
  end

  if wasFont then G.setFont(wasFont) end
  G.setColor(1, 1, 1, 1)
end

local function drawLabels(e, res)
  if e.label then
    for cid, label in pairs(e.labels) do drawLabel(e, label, res) end
  end
end

return {drawLabels = drawLabels}
