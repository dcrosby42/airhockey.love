local FSM = {
  DEFAULT_NAME = "FSM",
}

function FSM.getState(e, sname)
  sname = sname or FSM.DEFAULT_NAME
  if not e.states or not e.states[sname] then
    e:newComp('state', { name = sname, value = "start" })
  end
  return e.states[sname].value
end

function FSM.setState(e, svalue, sname)
  sname = sname or FSM.DEFAULT_NAME
  FSM.getState(e, sname)
  e.states[sname].value = svalue
end

return FSM
