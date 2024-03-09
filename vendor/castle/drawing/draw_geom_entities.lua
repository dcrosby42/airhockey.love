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
end
