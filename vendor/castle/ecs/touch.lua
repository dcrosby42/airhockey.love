local function eventToComponent(evt)
  return {
    touchid = evt.id,
    startx = evt.x,
    starty = evt.y,
    lastx = evt.x,
    lasty = evt.y,
    dx = evt.dx or 0,
    dy = evt.dy or 0,
  }
end

local function newComponent(e, touchEvt)
  e:newComp('touch', eventToComponent(touchEvt))
end

local function updateComponent(comp, evt)
  comp.lastx = evt.x
  comp.lasty = evt.y
  comp.dx = evt.dx or 0
  comp.dy = evt.dy or 0
end

return {
  newComponent = newComponent,
  eventToComponent = eventToComponent,
  updateComponent = updateComponent,
}
