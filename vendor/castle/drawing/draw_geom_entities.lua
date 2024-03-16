return function(e, res)
  if e.circles then
    for _, c in pairs(e.circles) do
      local style = "line"
      if c.fill then
        style = "fill"
      end
      love.graphics.setColor(c.color)
      love.graphics.circle(style, c.offx, c.offy, c.radius)
    end
  end

  if e.b and e.b.debug then
    local w, h = e.b.w, e.b.h
    local ox = e.b.cx * w
    local oy = e.b.cy * h
    local x, y = e.b.x, e.b.y
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", x - ox, y - oy, w, h)
  end

  if e.rect2s then
    for _, rect in pairs(e.rect2s) do
      local x, y, w, h = rect.x, rect.y, rect.w, rect.h
      local ox = rect.cx * w
      local oy = rect.cy * h
      love.graphics.setColor(rect.color)
      love.graphics.rectangle(rect.style, x - ox, y - oy, w, h)
    end
  end

  if e.circle2s then
    for _, c in pairs(e.circle2s) do
      love.graphics.setColor(c.color)
      love.graphics.circle(c.style, c.x, c.y, c.r)
    end
  end
end
