local E = require "modules.airhockey.entities"
local Debug = require("mydebug").sub("GoalScored", true, true)
local FSM = require "modules.airhockey.fsm"
local updateScoreBoard = require("modules.airhockey.funcs").updateScoreBoard
local incrementScore = require("modules.airhockey.funcs").incrementScore
local maxScoreReached = require("modules.airhockey.funcs").maxScoreReached

local GRACE_PERIOD = 2
local DRIFT_SPEED = 30

return defineUpdateSystem(
  hasTag("goal_scored"),
  function(e, estore, input, res)
    local state = FSM.getState(e)
    if state == "start" then
      Debug.println("goal for " .. e.states.winner.value)
      e:newComp("sound", { name = "puck_in_goal", sound = "score_goal" })

      -- update game_state: increment score for point winner
      local winner = e.states.winner.value

      local gameState = estore:getEntityByName("game_state").game_state
      incrementScore(gameState, winner)
      updateScoreBoard(estore, gameState)

      if maxScoreReached(gameState) then
        -- Transition to game over sequence
        E.game_over(estore, { winner = winner })
        estore:destroyEntity(e)
      else
        -- Enter grace period before puck reset
        FSM.setState(e, "grace_period")
        e:newComp("timer", { name = "grace_period", t = GRACE_PERIOD })
      end
    elseif state == "grace_period" then
      if e.timers.grace_period.alarm then
        -- Add the puck back to the table
        E.puck_drop(e:getParent(), res)
        -- Remove this goal_scored entity
        estore:destroyEntity(e)
      end
    end
  end
)
