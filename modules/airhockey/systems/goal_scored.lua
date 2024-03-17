local Debug = require("mydebug").sub("GoalScored", true, true)
local E = require "modules.airhockey.entities"

local GRACE_PERIOD = 2
local DRIFT_SPEED = 30

local fsm = {
  DEFAULT_NAME = "fsm",
}

function fsm.getState(e, sname)
  sname = sname or fsm.DEFAULT_NAME
  if not e.states or not e.states[sname] then
    e:newComp('state', { name = sname, value = "start" })
  end
  return e.states[sname].value
end

function fsm.setState(e, svalue, sname)
  sname = sname or fsm.DEFAULT_NAME
  fsm.getState(e, sname)
  e.states[sname].value = svalue
end

return defineUpdateSystem(
  hasTag("goal_scored"),
  function(e, estore, input, res)
    local state = fsm.getState(e)
    if state == "start" then
      Debug.println("goal for " .. e.states.winner.value)
      e:newComp("sound", { name = "puck_in_goal", sound = "score_goal" })
      e:newComp("timer", { name = "cooldown", t = GRACE_PERIOD })

      -- update game_state: increment score for point winner
      local winner = e.states.winner.value
      local gs = findEntity(estore, hasName("game_state"))
      local score = gs.states[winner].value + 1
      gs.states[winner].value = score

      -- Update the score
      local labelName = "score_" .. winner
      local scoreLabel = findEntity(estore, hasName(labelName))
      if scoreLabel then
        scoreLabel.states.score.value = score
        local txt = string.format("%02d", score)
        scoreLabel.label.text = txt
      end


      fsm.setState(e, "grace_period")
      return
    elseif state == "grace_period" then
      if e.timers.cooldown.alarm then
        -- Add the puck back to the table
        E.puck_drop(e:getParent(), res)
        fsm.setState(e, "done")
      end
      return
    end
  end
)
