local FSM = require "modules.airhockey.fsm"
local TweenHelpers = require "castle.tween.tween_helpers"


local function getScoreLabels(estore)
  local score1 = estore:getEntityByName("score_Player1")
  local score2 = estore:getEntityByName("score_Player2")
  return score1, score2
end

local function startScoreTweens(e, estore)
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

local function startShowWinner(e, estore)
  -- Find the score label entity for the winner:
  local score1, score2 = getScoreLabels(estore)
  local scoreLabelW = score1
  if e.states.winner.value ~= "Player1" then
    scoreLabelW = score2
  end
  -- Figure out the area we're on:
  local parent = scoreLabelW:getParent()
  local w, h = parent.box.w, parent.box.h

  -- (compute start/end positional params for the winner label tween)
  -- upper part of the screen:
  local voffset = -100
  -- (upside-down off to the left)
  local offright = -150
  local rot = math.pi
  if e.states.winner.value ~= "Player1" then
    -- lower part of the screen
    voffset = -voffset
    -- off to the right
    offright = w + 150
    -- rightside up
    rot = 0
  end

  -- Compute winner's color (red or blue prolly)
  local winColorStart = lcopy(scoreLabelW.label.color)
  winColorStart[4] = 0
  local winColorEnd = lcopy(winColorStart)
  winColorEnd[4] = 1

  -- Add a WINNER label
  local winnerLabel = parent:newEntity({
    { 'name', { name = "winner_label" } },
    { 'tr',   { x = offright, y = h / 2 + voffset } },
    {
      'label',
      {
        text = "WINNER",
        color = winColorStart,
        r = rot,
        w = 300,
        h = 100,
        cx = 0.5,
        cy = 0.5,
        align = "center",
        valign = "center",
        font = 'alarm_clock_medium',
        debug = false,
      },
    },

  })
  TweenHelpers.addTweens(winnerLabel, "slide_in", {
      label = { color = winColorEnd },
      tr = { x = w / 2, }
    },
    {
      duration = 1,
      easing = "outCubic",
    })
end

return defineUpdateSystem(
  hasTag("game_over"),
  function(e, estore, input, res)
    local state = FSM.getState(e)
    if state == "start" then
      startScoreTweens(e, estore)
      e:newComp('timer', { name = "sliding", t = 1 })
      FSM.setState(e, "sliding_scores")
    elseif state == "sliding_scores" then
      if e.timers.sliding.alarm then
        startShowWinner(e, estore)
        e:removeComp(e.timers.sliding)
        e:newComp('timer', { name = "winning", t = 1 })
        FSM.setState(e, "showing_winner")
      end
      -- local score1, score2 = getScoreLabels(estore)
      -- if score1 and score1.tween and score1.tween.finished then
      --   startShowWinner(e, estore)
      --   FSM.setState(e, "showing_winner")
      -- end
    elseif state == "showing_winner" then
      if e.timers.winning.alarm then
        FSM.setState(e, "finished")
        e:removeComp(e.timers.winning)
        print("DONE")
      end
    elseif state == "finished" then
    end
  end)
