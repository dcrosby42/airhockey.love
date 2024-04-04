local FSM = require "modules.airhockey.fsm"
local TweenHelpers = require "castle.tween.tween_helpers"


local function getScoreLabels(estore)
  local score1 = estore:getEntityByName("score_Player1")
  local score2 = estore:getEntityByName("score_Player2")
  return score1, score2
end

local function startAnimations(e, estore)
  local score1, score2 = getScoreLabels(estore)
  local parent = score1:getParent()
  local w, h = parent.box.w, parent.box.h
  local s = 1.5
  -- local d = 0.666
  local d = 1
  local score1Color = lcopy(score1.label.color)
  score1Color[4] = 1
  TweenHelpers.addTweens(score1, "slide", {
      label = { color = score1Color },
      tr = { x = w / 2, y = h * 0.25, sx = s, sy = s }
    },
    {
      duration = d,
      easing = "outQuint",
    })
  local score2Color = lcopy(score2.label.color)
  score2Color[4] = 1
  TweenHelpers.addTweens(score2, "slide", {
      label = { color = score2Color },
      tr = { x = w / 2, y = h * 0.75, sx = s, sy = s }
    },
    {
      duration = d,
      easing = "outQuint",
    })
end

return defineUpdateSystem(
  hasTag("game_over"),
  function(e, estore, input, res)
    local state = FSM.getState(e)
    if state == "start" then
      startAnimations(e, estore)
      FSM.setState(e, "sliding_stuff")
    elseif state == "sliding_stuff" then
      -- ...
    end
  end)
