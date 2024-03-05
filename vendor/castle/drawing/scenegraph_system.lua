local drawFuncs = {
  require('castle.drawing.draw_pic_entities'),
  -- DrawPic.drawAnims,
  require('castle.drawing.draw_screengrid_entity'),

  -- pic
  -- shapes
  -- physics
  -- button
  -- sound?
}

return function(estore, res)
  estore:walkEntities2(nil, function(e, proceed)
    -- Apply transformation (if any)
    love.graphics.push()
    if e.pos then
      love.graphics.translate(e.pos.x, e.pos.y)
    end
    if e.rot then
      love.graphics.rotate(e.rot.r)
    end
    if e.scale then
      love.graphics.scale(e.scale.x, e.scale.y)
    end

    -- Draw entity
    for i = 1, #drawFuncs do
      drawFuncs[i](e, res)
    end

    -- Draw children
    proceed()

    -- End transform
    love.graphics.pop()
  end)
end
