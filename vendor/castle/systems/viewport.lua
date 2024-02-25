-- update viewport pos based on viewport target
return defineUpdateSystem(hasComps('viewport', 'pos'), function(e, estore, input, res)
  estore:seekEntity(hasComps('viewportTarget', 'pos'), function(targetE)
    if e.viewport.targetName ~= '' then
      -- only verify name match if viewport.targetName is set
      if e.viewport.targetName ~= targetE.viewportTarget.name then
        return false -- next seekEntity
      end
    end
    e.pos.x = targetE.pos.x + targetE.viewportTarget.offx
    e.pos.y = targetE.pos.y + targetE.viewportTarget.offy
    return true
  end)
end)
