local E = require "modules.airhockey.entities"
local Debug = require("mydebug").sub("GoalScored", true, true)
local FSM = require "modules.airhockey.fsm"
local updateScoreBoard = require("modules.airhockey.funcs").updateScoreBoard
local incrementScore = require("modules.airhockey.funcs").incrementScore

local GRACE_PERIOD = 2
local DRIFT_SPEED = 30


return defineUpdateSystem(
  hasTag("goal_scored"),
  function(e, estore, input, res)
    local state = FSM.getState(e)
    if state == "start" then
      Debug.println("goal for " .. e.states.winner.value)
      e:newComp("sound", { name = "puck_in_goal", sound = "score_goal" })
      e:newComp("timer", { name = "cooldown", t = GRACE_PERIOD })

      -- update game_state: increment score for point winner
      local winner = e.states.winner.value

      local gameState = estore:getEntityByName("game_state")
      incrementScore(gameState, winner)
      updateScoreBoard(estore, gameState)

      FSM.setState(e, "grace_period")
    elseif state == "grace_period" then
      if e.timers.cooldown.alarm then
        -- Add the puck back to the table
        E.puck_drop(e:getParent(), res)
        FSM.setState(e, "done")
        -- Remove this goal_scored entity
        estore:destroyEntity(e)
      end
    end
  end
)
