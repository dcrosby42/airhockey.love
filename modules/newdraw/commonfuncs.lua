local C = {}

-- use bounds and pos to detect overlap of entities
function C.entitiesIntersect(e1, e2)
  error("reimplement me")
  -- if e1.bounds and e2.bounds and e1.pos and e2.pos then
  --   -- (use getPos() to properly account for parented entities)
  --   local x1, y1 = getPos(e1)
  --   local x2, y2 = getPos(e2)
  --   return math.rectanglesintersectwh(
  --     x1 - e1.bounds.offx, y1 - e1.bounds.offy, e1.bounds.w, e1.bounds.h,
  --     x2 - e2.bounds.offx, y2 - e2.bounds.offy, e2.bounds.w, e2.bounds.h)
  -- end
end

function C.findCollidingEntities(myEnt, estore, extraFilterFunc)
  error("reimplement me")
  -- if extraFilterFunc == nil then
  --   -- no extra filtering:
  --   return findEntities(estore, function(e)
  --     return e.eid ~= myEnt.eid and C.entitiesIntersect(myEnt, e)
  --   end)
  -- else
  --   return findEntities(estore, function(e)
  --     return e.eid ~= myEnt.eid and extraFilterFunc(e) and C.entitiesIntersect(myEnt, e)
  --   end)
  -- end
end

function C.firstCollidingEntity(myEnt, estore, extraFilterFunc)
  error("reimplement me")
  -- return findEntity(estore, function(e)
  --   return e.eid ~= myEnt.eid and extraFilterFunc(e) and C.entitiesIntersect(myEnt, e)
  -- end)
end

return C
