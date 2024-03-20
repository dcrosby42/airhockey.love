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

  -- bounds: draw only during debug
  if e.b and e.b.w and e.b.h and debugDraw(e.b, res) then
    local w, h = e.b.w, e.b.h
    local ox = e.b.cx * w
    local oy = e.b.cy * h
    local x, y = e.b.x, e.b.y
    -- draw a yellow rectangle:
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

-- --
-- -- POLYGON
-- --
-- if e.polygonShape then
--   local st = e.polygonLineStyle
--   local pol = e.polygonShape
--   if st and st.draw then
--     love.graphics.setColor(unpack(st.color))
--     love.graphics.setLineWidth(st.linewidth)
--     love.graphics.setLineStyle(st.linestyle)
--     local verts = {}
--     local x, y = e.pos.x, e.pos.y
--     for i = 1, #pol.vertices, 2 do
--       verts[i] = x + pol.vertices[i]
--       verts[i + 1] = y + pol.vertices[i + 1]
--     end
--     if st.closepolygon then
--       table.insert(verts, x + pol.vertices[1])
--       table.insert(verts, y + pol.vertices[2])
--     end
--     love.graphics.line(verts)
--   end
-- end
