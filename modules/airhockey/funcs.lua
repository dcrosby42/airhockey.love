local Funcs = {}
local inspect = require "inspect"

function Funcs.incrementScore(gameState, winner)
  gameState.scores[winner] = gameState.scores[winner] + 1
end

function Funcs.maxScoreReached(gameState)
  for _player, score in pairs(gameState.scores) do
    if score >= gameState.max_score then
      return true
    end
  end
  return false
end

function Funcs.updateScoreBoard(estore, gameState)
  for _, name in ipairs({ "Player1", "Player2" }) do
    local score = gameState.scores[name]
    local scoreLabel = estore:getEntityByName("score_" .. name)
    if scoreLabel then
      scoreLabel.states.score.value = score
      local txt = string.format("%02d", score)
      scoreLabel.label.text = txt
    end
  end
end

return Funcs
