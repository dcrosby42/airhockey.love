local Debug = require 'mydebug'
Debug = Debug.sub("TouchButton", true, true)
local EventHelpers = require 'castle.systems.eventhelpers'

return function(estore, input, res)
  estore:walkEntities(hasComps('touch2', 'button2'), function(e)
    local button = e.button2
    if button.kind == 'hold' then
      local touch = e.touch2
      local timer = e.timers and e.timers.holdbutton

      -- See if the button has been held long enough to trigger:
      if timer and timer.alarm then
        e:removeComp(timer)
        table.insert(input.events, {
          type = button.eventtype,
          state = button.eventstate,
          eid = e.eid,
          cid = button.cid,
        })
        Debug.println("fire event " .. button.eventtype)
      end

      if touch.state == "pressed" then
        e:newComp('timer', { name = "holdbutton", t = button.holdtime })
        Debug.println("begin hold")
      elseif touch.state == "released" then
        if timer then
          e:removeComp(timer)
          Debug.println("aborted")
        end
      end
    end
  end)
end
