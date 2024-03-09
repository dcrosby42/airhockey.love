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

  if e.b then
    local w, h = e.b.w, e.b.h
    local ox = e.b.cx * w
    local oy = e.b.cy * h
    local x, y = e.b.x, e.b.y
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", x - ox, y - oy, w, h)
  end
end
