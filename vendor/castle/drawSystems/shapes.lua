local ShapeFuncs = require('castle.drawSystems.shapefunctions')
return function(estore, res)
  estore:walkEntities(nil, function(e)
    if e.label and e.pos then ShapeFuncs.drawLabels(e, res) end
    -- TODO: more actual shape drawing
  end)
end

