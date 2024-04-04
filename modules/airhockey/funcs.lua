local Funcs = {}

function Funcs.incrementScore(gameState, winner)
  local score = gameState.states[winner].value + 1
  gameState.states[winner].value = score
end

function Funcs.updateScoreBoard(estore, gameState)
  for _, name in ipairs({ "Player1", "Player2" }) do
    local score = gameState.states[name].value
    local scoreLabel = estore:getEntityByName("score_" .. name)
    if scoreLabel then
      scoreLabel.states.score.value = score
      local txt = string.format("%02d", score)
      scoreLabel.label.text = txt
    end
  end
end

return Funcs
