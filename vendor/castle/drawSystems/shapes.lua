local ShapeFuncs = require('castle.drawSystems.shapefunctions')
return function(estore, res)
  estore:walkEntities(nil, function(e)
    if e.pos then
      ShapeFuncs.drawLabels(e, res)
      ShapeFuncs.drawRects(e, res)
      -- TODO: more actual shape drawing
    end
  end)
end
