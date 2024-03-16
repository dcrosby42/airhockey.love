local M = {}

-- Iterate event objects, match event.type to eventType.
-- Handlers is a table whose string keys point to functions.
-- When an event matches, event.state is used to select the proper func from handlers.
function M.handle(events, eventType, handlers)
  local rem = {} -- indexes of events to remove
  for i, evt in ipairs(events) do
    if evt.type == eventType then
      local fn = handlers[evt.state]
      if fn then
        local handled = fn(evt)
        if handled == true then
          rem[#rem + 1] = i -- mark event index for removal
        end
      end
    end
  end
  -- clear any removable events:
  for i = 1, #rem do
    table.remove(events, rem[i])
  end
end

function M.on(events, eventType, eventState, fn)
  for i = 1, #events do
    if events[i].type == eventType then
      if (not eventState) or events[i].state == eventState then
        fn(events[i])
      end
    end
  end
end

return M
