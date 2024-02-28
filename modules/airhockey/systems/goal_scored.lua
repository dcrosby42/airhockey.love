local Debug = require("mydebug").sub("GoalScored", true, true)
return defineUpdateSystem(
  hasTag("goal_scored"),
  function(e, estore, input, res)
    local s = e.states.fsm.value
    local nextS = s
    if s == "init" then
      Debug.println("init!")
      e:newComp("sound", { name = "puck_in_goal", sound = "score_goal" })
      nextS = "grace_period"
    elseif s == "grace_period" then
      --
    end
    if nextS ~= s then
      e.states.fsm.value = nextS
    end
  end
)
